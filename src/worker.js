// Tells on Cloudflare Workers.
// Static files (the page, styles, script) come from ./public.
// This Worker answers the small JSON API the old Rails app had:
//   GET  /tells(.json)      all tells, oldest first
//   GET  /tells/:id(.json)  one tell
//   POST /tells(.json)      add a tell: {"tell": {"message": "..."}}
//   GET  /last.json         {"word": last word of the newest tell}

const MIN_LENGTH = 10;
const MAX_LENGTH = 255; // the old MySQL column was a varchar(255)

const json = (body, init = {}) =>
  Response.json(body, {
    ...init,
    headers: { "cache-control": "no-store", ...init.headers },
  });

export function validate(message) {
  const errors = [];
  if (typeof message !== "string" || message.trim() === "") {
    errors.push("can't be blank");
  } else if ([...message].length < MIN_LENGTH) {
    errors.push(`is too short (minimum is ${MIN_LENGTH} characters)`);
  } else if ([...message].length > MAX_LENGTH) {
    errors.push(`is too long (maximum is ${MAX_LENGTH} characters)`);
  }
  return errors;
}

export function lastWord(message) {
  const words = (message ?? "").split(" ").filter(Boolean);
  return words.length ? words[words.length - 1] : "nil";
}

async function listTells(env) {
  const { results } = await env.DB.prepare(
    "SELECT id, message, created_at, updated_at FROM tells ORDER BY id",
  ).all();
  return json(results);
}

async function showTell(env, id) {
  const tell = await env.DB.prepare(
    "SELECT id, message, created_at, updated_at FROM tells WHERE id = ?",
  )
    .bind(id)
    .first();
  return tell ? json(tell) : json({ error: "not found" }, { status: 404 });
}

async function createTell(request, env) {
  // Only accept JSON, so a plain cross-site HTML form can't post here.
  if (!(request.headers.get("content-type") || "").includes("application/json")) {
    return json({ error: "expected application/json" }, { status: 415 });
  }
  let body;
  try {
    body = await request.json();
  } catch {
    return json({ error: "invalid JSON" }, { status: 400 });
  }
  const message = body?.tell?.message ?? body?.message;
  const errors = validate(message);
  if (errors.length) {
    return json({ message: errors }, { status: 422 });
  }
  const tell = await env.DB.prepare(
    "INSERT INTO tells (message) VALUES (?) RETURNING id, message, created_at, updated_at",
  )
    .bind(message)
    .first();
  return json(tell, {
    status: 201,
    headers: { location: `/tells/${tell.id}` },
  });
}

async function last(env) {
  const tell = await env.DB.prepare(
    "SELECT message FROM tells ORDER BY id DESC LIMIT 1",
  ).first();
  return json({ word: lastWord(tell?.message) });
}

export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);
    const method = request.method;

    if (pathname === "/last.json") {
      return method === "GET" ? last(env) : json({ error: "method not allowed" }, { status: 405, headers: { allow: "GET" } });
    }

    if (pathname === "/tells" || pathname === "/tells.json") {
      if (method === "GET") return listTells(env);
      if (method === "POST") return createTell(request, env);
      return json({ error: "method not allowed" }, { status: 405, headers: { allow: "GET, POST" } });
    }

    const match = pathname.match(/^\/tells\/(\d+)(?:\.json)?$/);
    if (match) {
      if (method === "GET") return showTell(env, Number(match[1]));
      return json({ error: "method not allowed" }, { status: 405, headers: { allow: "GET" } });
    }

    return env.ASSETS.fetch(request);
  },
};
