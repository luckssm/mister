import { describe, expect, it } from "vitest";

describe("@mister/engine", () => {
  it("loads its entry point", async () => {
    await expect(import("./index.js")).resolves.toBeDefined();
  });
});
