import from .components.dashboard { Dashboard }
import from .components.timer { Timer }
import from .components.ah_counter { AhCounter }
import from .components.grammarian { Grammarian }
import from .components.table_topics { TableTopics }
import from .components.meeting_planner { MeetingPlanner }
import from .components.member_progress { MemberProgress }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { Timer01Icon, Calculator01Icon, Book01Icon, Mic01Icon, CalendarAdd01Icon, ChampionIcon }
cl import ".styles.global.css";

def:pub app() -> JsxElement {
    has active_page: str = "dashboard";
    has menu_open: bool = False;

    nav_items: list = [
        {"id": "timer", "label": "Timer"},
        {"id": "ah-counter", "label": "Ah-Counter"},
        {"id": "grammarian", "label": "Grammarian"},
        {"id": "table-topics", "label": "Table Topics"},
        {"id": "planner", "label": "Planner"},
        {"id": "progress", "label": "Progress"}
    ];

    def nav_cls(page: str) -> str {
        base: str = "flex items-center gap-1.5 px-3 py-1.5 rounded-lg font-medium text-xs transition-all duration-200 whitespace-nowrap ";
        if active_page == page {
            return base + "bg-amber-400 text-amber-950 shadow-sm shadow-amber-400/30";
        }
        return base + "text-white/70 hover:text-white hover:bg-white/10";
    }

    def mobile_nav_cls(page: str) -> str {
        base: str = "flex items-center gap-3 px-4 py-3 rounded-xl font-medium text-sm transition-all duration-200 ";
        if active_page == page {
            return base + "bg-amber-400 text-amber-950";
        }
        return base + "text-white/80 hover:bg-white/10 hover:text-white";
    }

    def nav_icon_cls(page: str) -> str {
        if active_page == page {
            return "size-3.5 text-amber-950";
        }
        return "size-3.5 text-white/70";
    }

    return <div className="min-h-screen bg-background">
        <nav className="sticky top-0 z-50 glass shadow-lg shadow-primary/10">
            <div className="absolute inset-0 hero-gradient opacity-95"></div>
            <div className="relative max-w-6xl mx-auto px-4 py-3 flex items-center justify-between gap-4">
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "dashboard"; menu_open = False; }}
                    className="flex items-center gap-2.5 shrink-0 group"
                >
                    <div className="size-8 rounded-lg bg-amber-400 flex items-center justify-center text-amber-950 font-black text-sm shadow-md shadow-amber-400/40">
                        TM
                    </div>
                    <span className="font-bold text-white text-sm hidden sm:block tracking-tight">JaseciLabs TM</span>
                </button>

                <div className="hidden md:flex items-center gap-0.5 flex-1 justify-center">
                    {[<button
                        key={str(nav_items[i]["id"])}
                        onClick={lambda(e: MouseEvent) -> None { active_page = str(nav_items[i]["id"]); }}
                        className={nav_cls(str(nav_items[i]["id"]))}
                    >
                        {str(nav_items[i]["id"]) == "timer" and <HugeiconsIcon icon={Timer01Icon} strokeWidth={2} className={nav_icon_cls("timer")} />}
                        {str(nav_items[i]["id"]) == "ah-counter" and <HugeiconsIcon icon={Calculator01Icon} strokeWidth={2} className={nav_icon_cls("ah-counter")} />}
                        {str(nav_items[i]["id"]) == "grammarian" and <HugeiconsIcon icon={Book01Icon} strokeWidth={2} className={nav_icon_cls("grammarian")} />}
                        {str(nav_items[i]["id"]) == "table-topics" and <HugeiconsIcon icon={Mic01Icon} strokeWidth={2} className={nav_icon_cls("table-topics")} />}
                        {str(nav_items[i]["id"]) == "planner" and <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={2} className={nav_icon_cls("planner")} />}
                        {str(nav_items[i]["id"]) == "progress" and <HugeiconsIcon icon={ChampionIcon} strokeWidth={2} className={nav_icon_cls("progress")} />}
                        {str(nav_items[i]["label"])}
                    </button> for i in range(len(nav_items))]}
                </div>

                <button
                    className="md:hidden flex flex-col gap-1.5 p-2 rounded-lg hover:bg-white/10 transition-colors"
                    onClick={lambda(e: MouseEvent) -> None { menu_open = not menu_open; }}
                >
                    <span className="block w-5 h-0.5 bg-white/80 rounded-full"></span>
                    <span className="block w-5 h-0.5 bg-white/80 rounded-full"></span>
                    <span className="block w-5 h-0.5 bg-white/80 rounded-full"></span>
                </button>
            </div>

            {menu_open and <div className="relative md:hidden hero-gradient border-t border-white/10 px-4 py-3 flex flex-col gap-1">
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "timer"; menu_open = False; }}
                    className={mobile_nav_cls("timer")}
                >
                    <HugeiconsIcon icon={Timer01Icon} strokeWidth={2} className="size-4" />
                    Timer
                </button>
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "ah-counter"; menu_open = False; }}
                    className={mobile_nav_cls("ah-counter")}
                >
                    <HugeiconsIcon icon={Calculator01Icon} strokeWidth={2} className="size-4" />
                    Ah-Counter
                </button>
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "grammarian"; menu_open = False; }}
                    className={mobile_nav_cls("grammarian")}
                >
                    <HugeiconsIcon icon={Book01Icon} strokeWidth={2} className="size-4" />
                    Grammarian
                </button>
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "table-topics"; menu_open = False; }}
                    className={mobile_nav_cls("table-topics")}
                >
                    <HugeiconsIcon icon={Mic01Icon} strokeWidth={2} className="size-4" />
                    Table Topics
                </button>
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "planner"; menu_open = False; }}
                    className={mobile_nav_cls("planner")}
                >
                    <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={2} className="size-4" />
                    Planner
                </button>
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "progress"; menu_open = False; }}
                    className={mobile_nav_cls("progress")}
                >
                    <HugeiconsIcon icon={ChampionIcon} strokeWidth={2} className="size-4" />
                    Progress
                </button>
            </div>}
        </nav>

        <main>
            {<Dashboard onNavigate={lambda(page: str) -> None { active_page = page; menu_open = False; }} /> if active_page == "dashboard"
                else <Timer /> if active_page == "timer"
                else <AhCounter /> if active_page == "ah-counter"
                else <Grammarian /> if active_page == "grammarian"
                else <TableTopics /> if active_page == "table-topics"
                else <MeetingPlanner /> if active_page == "planner"
                else <MemberProgress />}
        </main>
    </div>;
}
