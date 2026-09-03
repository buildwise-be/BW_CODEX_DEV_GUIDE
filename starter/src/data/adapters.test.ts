import { describe, expect, it } from "vitest";
import { demoDataAdapter } from "./adapters";

describe("demoDataAdapter", () => {
  it("returns projects with the fields required by the project view", async () => {
    const items = await demoDataAdapter.getProjects();
    expect(items.length).toBeGreaterThan(0);
    expect(items[0]).toEqual(expect.objectContaining({ id: expect.any(String), name: expect.any(String), status: expect.any(String), progress: expect.any(Number) }));
  });

  it("returns KPI values with a target and trend", async () => {
    const items = await demoDataAdapter.getKpis();
    expect(items.length).toBe(4);
    expect(items.every((item) => item.value && item.target && item.change)).toBe(true);
  });
});
