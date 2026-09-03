import { ArrowDownRight, ArrowUpRight, Minus } from "lucide-react";
import type { Kpi } from "../types";

export function MetricCard({ kpi }: { kpi: Kpi }) {
  const Icon = kpi.direction === "up" ? ArrowUpRight : kpi.direction === "down" ? ArrowDownRight : Minus;
  return (
    <article className={`metric-card metric-${kpi.tone}`}>
      <div className="metric-label">{kpi.label}</div>
      <div className="metric-value-row"><strong>{kpi.value}</strong><span className={`metric-change ${kpi.direction}`}><Icon size={15} /> {kpi.change}</span></div>
      <div className="metric-target">Objectif <strong>{kpi.target}</strong></div>
    </article>
  );
}
