import { describe, expect, it } from "vitest";

describe("@mister/harness", () => {
  it("loads its entry point", async () => {
    await expect(import("./index.js")).resolves.toBeDefined();
  });
});
