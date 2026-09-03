import { describe, expect, it } from "vitest";
import { renderToStaticMarkup } from "react-dom/server";
import { createElement } from "react";
import App from "./App";

describe("socle neutre — les tests métier seront ajoutés par Codex", () => {
  it("affiche le logo et indique que le parcours reste à construire", () => {
    const html = renderToStaticMarkup(createElement(App));
    expect(html).toContain('alt="Buildwise"');
    expect(html).toContain("Application en construction");
    expect(html).toContain("Le parcours métier reste à construire");
  });
});
