// Tells: an endless exquisite corpse. You see only the last word; continue
// the story from it, then read the whole thing back.
(() => {
  const list = document.querySelector("#tells-list > ul");
  const readButton = document.querySelector(".pulley");
  const form = document.getElementById("new-tell");
  const input = form.elements.message;
  const button = form.querySelector("button[type=submit]");
  const lastWordEl = document.querySelector(".tell-last-word");
  const errorEl = document.querySelector(".tell-error");

  // Each message starts hidden. Revealing goes character by character from
  // the end of the newest tell backwards; hiding goes the other way.
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
    } else {
      if (current === visible.length - 1 && visible[current].length === 0) return;
      if (visible[current].length === 0) current++;
      hidden[current].push(visible[current].shift());
    }
    paragraphs[current].textContent = visible[current].join("");
  }

  const allShown = () => hidden.every((chars) => chars.length === 0);
  const allHidden = () => visible.every((chars) => chars.length === 0);

  function updateReadButton() {
    const open = hidden.length > 0 && allShown();
    readButton.textContent = open ? "hide" : "read";
    readButton.setAttribute("aria-expanded", String(open));
    readButton.hidden = hidden.length === 0;
  }

  // Pull the story out (or tuck it back in), a few characters per frame so
  // it takes about a second whatever its length.
  let pulling = null;
  function pull(direction) {
    if (pulling) cancelAnimationFrame(pulling);
    const done = direction > 0 ? allShown : allHidden;
    const total = hidden.reduce((n, c) => n + c.length, 0) + visible.reduce((n, c) => n + c.length, 0);
    const perFrame = Math.max(1, Math.ceil(total / 60));
    const tick = () => {
      for (let i = 0; i < perFrame && !done(); i++) step(direction);
      pulling = done() ? null : requestAnimationFrame(tick);
      if (!pulling) updateReadButton();
    };
    tick();
  }

  readButton.addEventListener("click", () => pull(allShown() ? -1 : 1));

  function setLastWord(message) {
    const words = (message || "").split(" ").filter(Boolean);
    lastWordEl.textContent = words.length ? words[words.length - 1] : "";
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
        setLastWord(body.message);
        input.value = "";
        pull(1); // show the whole story with the new tell at the end
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
    .then((tells) => {
      tells.forEach(addTell);
      if (tells.length) setLastWord(tells[tells.length - 1].message);
      updateReadButton();
    })
    .catch(() => updateReadButton());
})();
