import { test } from "node:test";
import assert from "node:assert/strict";
import { validate, lastWord } from "../src/worker.js";

test("validate matches the old Rails rules", () => {
  assert.deepEqual(validate(""), ["can't be blank"]);
  assert.deepEqual(validate("   "), ["can't be blank"]);
  assert.deepEqual(validate(undefined), ["can't be blank"]);
  assert.deepEqual(validate("too short"), ["is too short (minimum is 10 characters)"]);
  assert.deepEqual(validate("long enough!"), []);
  assert.deepEqual(validate("x".repeat(256)), ["is too long (maximum is 255 characters)"]);
});

test("lastWord takes the last space-separated word", () => {
  assert.equal(lastWord("once upon a time"), "time");
  assert.equal(lastWord("trailing space "), "space");
  assert.equal(lastWord(undefined), "nil");
});
