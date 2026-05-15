import from .components.dashboard { Dashboard }
import from .components.timer { Timer }
import from .components.ah_counter { AhCounter }
import from .components.grammarian { Grammarian }
import from .components.table_topics { TableTopics }
import from .components.meeting_planner { MeetingPlanner }
import from .components.member_progress { MemberProgress }
import from .lib.utils { cn }
import ".styles.global.css";

def:pub app() -> JsxElement {
    has active_page: str = "dashboard";

    def nav_cls(page: str) -> str {
        return "px-3 py-1.5 rounded-lg font-medium text-xs transition-colors " + ("bg-primary text-primary-foreground" if active_page == page else "text-muted-foreground hover:bg-muted");
    }

    def navigate(page: str) -> None {
        active_page = page;
    }

    return <div className="min-h-screen bg-background">
        <nav className="border-b border-border bg-card px-4 py-2 sticky top-0 z-10">
            <div className="max-w-5xl mx-auto flex items-center gap-1 flex-wrap">
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "dashboard"; }} className="font-bold text-foreground mr-3 text-sm hover:text-primary transition-colors">
                    🎤 TM
                </button>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "timer"; }} className={nav_cls("timer")}>⏱️ Timer</button>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "ah-counter"; }} className={nav_cls("ah-counter")}>🔢 Ah-Counter</button>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "grammarian"; }} className={nav_cls("grammarian")}>📝 Grammarian</button>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "table-topics"; }} className={nav_cls("table-topics")}>🗣️ Table Topics</button>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "planner"; }} className={nav_cls("planner")}>📅 Planner</button>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "progress"; }} className={nav_cls("progress")}>🏆 Progress</button>
            </div>
        </nav>
        {<Dashboard onNavigate={navigate} /> if active_page == "dashboard"
            else <Timer /> if active_page == "timer"
            else <AhCounter /> if active_page == "ah-counter"
            else <Grammarian /> if active_page == "grammarian"
            else <TableTopics /> if active_page == "table-topics"
            else <MeetingPlanner /> if active_page == "planner"
            else <MemberProgress />}
    </div>;
}
