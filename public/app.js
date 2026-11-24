// Tells: read the story by dragging sideways, then continue it from its last word.
// A plain-JS port of the old Backbone views (read_view, write_view, tell_view).
(() => {
  const list = document.querySelector("#tells-list > ul");
  const read = document.getElementById("read");
  const form = document.getElementById("new-tell");
  const input = form.elements.message;
  const button = form.querySelector("button");
  const lastWordEl = document.querySelector(".tell-last-word");
  const errorEl = document.querySelector(".tell-error");

  // Each message starts hidden. Dragging right reveals characters from the end
  // of the newest tell backwards; dragging left hides them again.
  const hidden = [];
  const visible = [];
  const paragraphs = [];
  let current = -1;

  function addTell(tell) {
    const li = document.createElement("li");
    const p = document.createElement("p");
    p.className = "told";
    const info = document.createElement("div");
    info.className = "info";
    info.textContent = tell.created_at;
    li.append(p, info);
    list.append(li);

    hidden.push([...tell.message]);
    visible.push([]);
    paragraphs.push(p);
    current = hidden.length - 1;
  }

  function step(direction) {
    if (current < 0) return;
    if (direction > 0) {
      if (current === 0 && hidden[0].length === 0) return;
      if (hidden[current].length === 0) current--;
      visible[current].unshift(hidden[current].pop());
    } else if (direction < 0) {
      if (current === visible.length - 1 && visible[current].length === 0) return;
      if (visible[current].length === 0) current++;
      hidden[current].push(visible[current].shift());
    } else {
      return;
    }
    paragraphs[current].textContent = visible[current].join("");
  }

  // Clicking the arrow pulls the whole story out (or tucks it back in once it
  // is all showing), a few characters per frame so it still feels pulled.
  const pulley = document.querySelector(".pulley");
  let pulling = null;
  const allShown = () => hidden.every((chars) => chars.length === 0);
  const allHidden = () => visible.every((chars) => chars.length === 0);
  pulley.addEventListener("click", () => {
    if (pulling) cancelAnimationFrame(pulling);
    const direction = allShown() ? -1 : 1;
    const done = direction > 0 ? allShown : allHidden;
    const total = hidden.reduce((n, chars) => n + chars.length, 0) +
      visible.reduce((n, chars) => n + chars.length, 0);
    const perFrame = Math.max(1, Math.ceil(total / 60)); // about a second
    const tick = () => {
      for (let i = 0; i < perFrame && !done(); i++) step(direction);
      pulling = done() ? null : requestAnimationFrame(tick);
    };
    tick();
  });
  pulley.addEventListener("keydown", (e) => {
    if (e.key === "Enter" || e.key === " ") {
      e.preventDefault();
      pulley.click();
    }
  });

  let lastX = null;
  read.addEventListener("pointerdown", (e) => {
    if (e.target.closest(".pulley")) return;
    lastX = e.clientX;
    read.setPointerCapture(e.pointerId);
  });
  read.addEventListener("pointermove", (e) => {
    if (lastX === null) return;
    if (pulling) { cancelAnimationFrame(pulling); pulling = null; }
    step(Math.sign(e.clientX - lastX));
    lastX = e.clientX;
  });
  const stop = () => { lastX = null; };
  read.addEventListener("pointerup", stop);
  read.addEventListener("pointercancel", stop);

  async function refreshLastWord() {
    const res = await fetch("/last.json");
    if (res.ok) lastWordEl.textContent = (await res.json()).word;
  }

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    errorEl.textContent = "";
    button.disabled = true;
    try {
      const res = await fetch("/tells", {
        method: "POST",
        headers: { "content-type": "application/json", accept: "application/json" },
        body: JSON.stringify({ tell: { message: input.value } }),
      });
      const body = await res.json();
      if (res.ok) {
        addTell(body);
        input.value = "";
        refreshLastWord();
      } else if (body.message) {
        errorEl.textContent = `Message ${body.message.join(", ")}.`;
      } else {
        errorEl.textContent = "Something went wrong. Try again.";
      }
    } catch {
      errorEl.textContent = "Something went wrong. Try again.";
    } finally {
      button.disabled = false;
    }
  });

  fetch("/tells")
    .then((res) => res.json())
    .then((tells) => tells.forEach(addTell))
    .catch(() => {});
  refreshLastWord();
})();
