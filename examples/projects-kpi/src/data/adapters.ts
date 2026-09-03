import { projects } from "./projects";
import { kpis } from "./kpis";
import type { Kpi, Project } from "../types";

/** The UI depends on this small contract, so a real API can replace the demo data later. */
export interface BusinessDataAdapter {
  getProjects(): Promise<Project[]>;
  getKpis(): Promise<Kpi[]>;
}

export const demoDataAdapter: BusinessDataAdapter = {
  async getProjects() {
    return projects;
  },
  async getKpis() {
    return kpis;
  },
};
