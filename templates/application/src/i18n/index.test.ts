import { describe, expect, it } from "vitest";
import fr from "./messages/fr.json";
import nl from "./messages/nl.json";
import { isLanguage, t } from "./index";

describe("bilinguisme", () => {
  it("conserve exactement les mêmes clés en français et néerlandais", () => {
    expect(Object.keys(nl).sort()).toEqual(Object.keys(fr).sort());
    expect([...Object.values(fr), ...Object.values(nl)].every((value) => value.trim().length > 0)).toBe(true);
  });
  it("traduit une clé dans les deux langues", () => {
    expect(t("app.ready.title", "fr")).toBe("Votre besoin a été cadré");
    expect(t("app.ready.title", "nl")).toBe("Uw behoefte is afgebakend");
  });
  it("n'accepte que fr et nl", () => {
    expect(isLanguage("fr")).toBe(true);
    expect(isLanguage("nl")).toBe(true);
    expect(isLanguage("en")).toBe(false);
  });
});
