import type { Kpi } from "../types";

export const kpis: Kpi[] = [
  { label: "Projets actifs", value: "24", change: "+12 %", direction: "up", target: "22", tone: "teal" },
  { label: "Projets dans les délais", value: "83 %", change: "+6 pts", direction: "up", target: "80 %", tone: "blue" },
  { label: "Délai moyen de décision", value: "4,2 j", change: "-0,8 j", direction: "up", target: "5 j", tone: "purple" },
  { label: "Points à arbitrer", value: "7", change: "+2", direction: "down", target: "< 5", tone: "orange" },
];
