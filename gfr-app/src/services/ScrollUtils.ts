import scrolls from "@/assets/scrolls.json";

export type ScrollType = "normal" | "rare" | "legendary" | "cursed" | "removed"

/**
 * As per scrolls.json
 */
export interface Scroll {
    type: ScrollType,
    name: string,
    link: string,
    imgTitle: string,
    desc: string,
    descEnhanced: string | null
}
export default {
    getScrolls(): Scroll[] {
        return (scrolls as Scroll[]).filter(s => s.type !== "removed" && s.type !== "cursed")
    },

    getScrollIndexByName(name: string): number {
        return this.getScrolls().findIndex(s => s.name === name)
    }
}