import from .components.timer { Timer }
import from .components.ah_counter { AhCounter }
import from .lib.utils { cn }
import ".styles.global.css";

def:pub app() -> JsxElement {
    has active_page: str = "timer";

    timer_cls: str = "px-4 py-2 rounded-lg font-medium text-sm transition-colors " + ("bg-primary text-primary-foreground" if active_page == "timer" else "text-muted-foreground hover:bg-muted");
    ah_cls: str = "px-4 py-2 rounded-lg font-medium text-sm transition-colors " + ("bg-primary text-primary-foreground" if active_page == "ah-counter" else "text-muted-foreground hover:bg-muted");

    return <div className="min-h-screen bg-background">
        <nav className="border-b border-border bg-card px-4 py-3">
            <div className="max-w-3xl mx-auto flex items-center gap-2">
                <span className="font-bold text-foreground mr-4">🎤 TM Manager</span>
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "timer"; }}
                    className={timer_cls}
                >
                    ⏱️ Timer
                </button>
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_page = "ah-counter"; }}
                    className={ah_cls}
                >
                    🔢 Ah-Counter
                </button>
            </div>
        </nav>
        {<Timer /> if active_page == "timer" else <AhCounter />}
    </div>;
}
