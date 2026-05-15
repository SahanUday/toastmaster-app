import from ..lib.utils { cn }
import from .timer { Timer }
import from .ah_counter { AhCounter }
import from .grammarian { Grammarian }
import from .table_topics { TableTopics }
import from .meeting_planner { MeetingPlanner }
import from .member_progress { MemberProgress }

glob dash_nav_ref: dict = {"page": "dashboard"};

def:pub Dashboard(onNavigate: Any) -> JsxElement {
    def go(page: str) -> None {
        if onNavigate {
            onNavigate(page);
        }
    }

    tools: list = [
        {"id": "timer", "icon": "⏱️", "title": "Timer", "desc": "Track speech times with green/yellow/red signals", "color": "bg-green-500/10 border-green-500/30 hover:bg-green-500/20"},
        {"id": "ah-counter", "icon": "🔢", "title": "Ah-Counter", "desc": "Count filler words per speaker", "color": "bg-blue-500/10 border-blue-500/30 hover:bg-blue-500/20"},
        {"id": "grammarian", "icon": "📝", "title": "Grammarian", "desc": "Word of the Day + grammar notes", "color": "bg-purple-500/10 border-purple-500/30 hover:bg-purple-500/20"},
        {"id": "table-topics", "icon": "🗣️", "title": "Table Topics", "desc": "Track impromptu speakers and times", "color": "bg-orange-500/10 border-orange-500/30 hover:bg-orange-500/20"},
        {"id": "planner", "icon": "📅", "title": "Meeting Planner", "desc": "Schedule meetings and assign roles", "color": "bg-yellow-500/10 border-yellow-500/30 hover:bg-yellow-500/20"},
        {"id": "progress", "icon": "🏆", "title": "Member Progress", "desc": "Track Pathways speech completions", "color": "bg-red-500/10 border-red-500/30 hover:bg-red-500/20"}
    ];

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-4xl mx-auto flex flex-col gap-8">
            <div className="text-center flex flex-col gap-3 py-6">
                <div className="text-5xl">🎤</div>
                <h1 className="text-4xl font-bold text-foreground">JaseciLabs TM Manager</h1>
                <p className="text-muted-foreground text-lg">Your complete Toastmasters meeting toolkit</p>
            </div>

            <div>
                <h2 className="text-lg font-semibold mb-4 text-muted-foreground uppercase tracking-wide text-sm">Meeting Tools</h2>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {[<button
                        key={str(tools[i]["id"])}
                        onClick={lambda(e: MouseEvent) -> None { go(str(tools[i]["id"])); }}
                        className={cn(["rounded-xl border p-5 text-left transition-colors cursor-pointer", str(tools[i]["color"])])}
                    >
                        <div className="flex items-start gap-4">
                            <span className="text-3xl">{str(tools[i]["icon"])}</span>
                            <div className="flex flex-col gap-1">
                                <span className="font-semibold text-foreground text-base">{str(tools[i]["title"])}</span>
                                <span className="text-sm text-muted-foreground">{str(tools[i]["desc"])}</span>
                            </div>
                        </div>
                    </button> for i in range(len(tools))]}
                </div>
            </div>

            <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-3">📋 Meeting Roles Quick Reference</h2>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-2 text-sm">
                    <div className="flex gap-2 p-2 rounded-lg bg-muted">
                        <span>🎙️</span><span><strong>Toastmaster of the Day</strong> — Runs the meeting</span>
                    </div>
                    <div className="flex gap-2 p-2 rounded-lg bg-muted">
                        <span>⏱️</span><span><strong>Timer</strong> — Tracks speech times</span>
                    </div>
                    <div className="flex gap-2 p-2 rounded-lg bg-muted">
                        <span>🔢</span><span><strong>Ah-Counter</strong> — Counts filler words</span>
                    </div>
                    <div className="flex gap-2 p-2 rounded-lg bg-muted">
                        <span>📝</span><span><strong>Grammarian</strong> — Word of the Day + grammar</span>
                    </div>
                    <div className="flex gap-2 p-2 rounded-lg bg-muted">
                        <span>🗣️</span><span><strong>Table Topics Master</strong> — Impromptu speaking</span>
                    </div>
                    <div className="flex gap-2 p-2 rounded-lg bg-muted">
                        <span>🔍</span><span><strong>General Evaluator</strong> — Evaluates the meeting</span>
                    </div>
                    <div className="flex gap-2 p-2 rounded-lg bg-muted">
                        <span>💬</span><span><strong>Speech Evaluator</strong> — Evaluates prepared speeches</span>
                    </div>
                    <div className="flex gap-2 p-2 rounded-lg bg-muted">
                        <span>🚪</span><span><strong>Sergeant at Arms</strong> — Setup & welcomes guests</span>
                    </div>
                </div>
            </div>
        </div>
    </div>;
}
