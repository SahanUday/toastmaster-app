import from .components.timer { Timer }
import from .components.ah_counter { AhCounter }
import from .components.meeting_planner { MeetingPlanner }
import from .lib.utils { cn }
import ".styles.global.css";

def:pub app() -> JsxElement {
    has active_page: str = "timer";

    def nav_cls(page: str) -> str {
        return "px-4 py-2 rounded-lg font-medium text-sm transition-colors " + ("bg-primary text-primary-foreground" if active_page == page else "text-muted-foreground hover:bg-muted");
    }

    return <div className="min-h-screen bg-background">
        <nav className="border-b border-border bg-card px-4 py-3 sticky top-0 z-10">
            <div className="max-w-4xl mx-auto flex items-center gap-2 flex-wrap">
                <span className="font-bold text-foreground mr-2">🎤 TM Manager</span>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "timer"; }} className={nav_cls("timer")}>
                    ⏱️ Timer
                </button>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "ah-counter"; }} className={nav_cls("ah-counter")}>
                    🔢 Ah-Counter
                </button>
                <button onClick={lambda(e: MouseEvent) -> None { active_page = "planner"; }} className={nav_cls("planner")}>
                    📅 Meeting Planner
                </button>
            </div>
        </nav>
        {<Timer /> if active_page == "timer" else <AhCounter /> if active_page == "ah-counter" else <MeetingPlanner />}
    </div>;
}
