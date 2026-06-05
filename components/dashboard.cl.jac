import from .ui.card { Card, CardContent }
import from .ui.badge { Badge }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { Timer01Icon, Calculator01Icon, Book01Icon, Mic01Icon, CalendarAdd01Icon, ChampionIcon, ArrowRight01Icon }

def:pub Dashboard(onNavigate: any) -> JsxElement {
    def go(page: str) -> None {
        if onNavigate {
            onNavigate(page);
        }
    }

    tools: list = [
        {"id": "timer", "icon": "timer", "title": "Speech Timer", "desc": "Green / yellow / red light signals with presets for every speech type", "badge": "In-Session", "color": "blue"},
        {"id": "ah-counter", "icon": "calc", "title": "Ah-Counter", "desc": "Count filler words per speaker with one-tap tracking", "badge": "In-Session", "color": "purple"},
        {"id": "grammarian", "icon": "book", "title": "Grammarian", "desc": "Set the Word of the Day and log grammar observations", "badge": "In-Session", "color": "emerald"},
        {"id": "table-topics", "icon": "mic", "title": "Table Topics", "desc": "Track impromptu speakers and their times live", "badge": "In-Session", "color": "rose"},
        {"id": "planner", "icon": "calendar", "title": "Meeting Planner", "desc": "Schedule meetings and assign roles to members", "badge": "Planning", "color": "amber"},
        {"id": "progress", "icon": "trophy", "title": "Member Progress", "desc": "Track Pathways speech completions per member", "badge": "Club", "color": "gold"}
    ];

    roles: list = [
        {"emoji": "🎙️", "name": "Toastmaster of the Day", "desc": "Runs the entire meeting", "type": "leadership"},
        {"emoji": "⏱️", "name": "Timer", "desc": "Tracks speech times with light signals", "type": "support"},
        {"emoji": "🔢", "name": "Ah-Counter", "desc": "Counts filler words and reports at end", "type": "support"},
        {"emoji": "📝", "name": "Grammarian", "desc": "Word of the Day + grammar feedback", "type": "support"},
        {"emoji": "🗣️", "name": "Table Topics Master", "desc": "Runs the impromptu speaking segment", "type": "leadership"},
        {"emoji": "🔍", "name": "General Evaluator", "desc": "Evaluates the entire meeting", "type": "evaluation"},
        {"emoji": "💬", "name": "Speech Evaluator", "desc": "Evaluates prepared speeches", "type": "evaluation"},
        {"emoji": "🚪", "name": "Sergeant at Arms", "desc": "Setup, welcomes guests, manages logistics", "type": "support"}
    ];

    def icon_bg(color: str) -> str {
        if color == "blue" { return "bg-blue-500/10 text-blue-600"; }
        elif color == "purple" { return "bg-purple-500/10 text-purple-600"; }
        elif color == "emerald" { return "bg-emerald-500/10 text-emerald-600"; }
        elif color == "rose" { return "bg-rose-500/10 text-rose-600"; }
        elif color == "amber" { return "bg-amber-500/10 text-amber-600"; }
        return "bg-amber-400/15 text-amber-700";
    }

    def badge_cls(badge: str) -> str {
        if badge == "Planning" { return "bg-amber-100 text-amber-800 border-amber-200"; }
        elif badge == "Club" { return "bg-emerald-100 text-emerald-800 border-emerald-200"; }
        return "bg-blue-100 text-blue-800 border-blue-200";
    }

    def role_cls(rtype: str) -> str {
        if rtype == "leadership" { return "bg-primary/5 border-primary/20"; }
        elif rtype == "evaluation" { return "bg-amber-50 border-amber-200/60"; }
        return "bg-muted/60 border-border";
    }

    return <div className="min-h-screen bg-background">
        <div className="relative overflow-hidden">
            <div className="absolute inset-0">
                <img
                    src="https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=1920&q=80"
                    alt="Public speaking conference"
                    className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 hero-gradient opacity-90"></div>
                <div className="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-background/80"></div>
            </div>

            <div className="relative px-6 py-20 md:py-32">
                <div className="max-w-4xl mx-auto text-center flex flex-col gap-5">
                    <div className="inline-flex items-center justify-center gap-2 bg-white/10 backdrop-blur-sm border border-white/20 rounded-full px-4 py-1.5 mx-auto">
                        <span className="size-2 rounded-full bg-amber-400 animate-pulse"></span>
                        <span className="text-white/90 text-xs font-medium tracking-wide uppercase">JaseciLabs Toastmasters</span>
                    </div>
                    <h1 className="text-4xl md:text-6xl font-bold text-white leading-tight tracking-tight">
                        Your Complete
                        <span className="block text-amber-400">Meeting Toolkit</span>
                    </h1>
                    <p className="text-white/75 text-lg max-w-2xl mx-auto leading-relaxed">
                        Everything you need to run a flawless Toastmasters meeting — from timing speeches to tracking member progress.
                    </p>
                    <div className="flex flex-wrap justify-center gap-3 mt-2">
                        <div className="flex items-center gap-2 bg-white/10 backdrop-blur-sm border border-white/20 rounded-full px-4 py-2">
                            <span className="size-1.5 rounded-full bg-amber-400 inline-block shrink-0"></span>
                            <span className="text-white/90 text-sm font-medium">6 Powerful Tools</span>
                        </div>
                        <div className="flex items-center gap-2 bg-white/10 backdrop-blur-sm border border-white/20 rounded-full px-4 py-2">
                            <span className="size-1.5 rounded-full bg-amber-400 inline-block shrink-0"></span>
                            <span className="text-white/90 text-sm font-medium">Built for Toastmasters</span>
                        </div>
                        <div className="flex items-center gap-2 bg-white/10 backdrop-blur-sm border border-white/20 rounded-full px-4 py-2">
                            <span className="size-1.5 rounded-full bg-amber-400 inline-block shrink-0"></span>
                            <span className="text-white/90 text-sm font-medium">Works on Any Device</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div className="max-w-5xl mx-auto px-4 pt-8 pb-16 flex flex-col gap-12">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div className="bg-card rounded-2xl border border-border p-5 text-center shadow-sm">
                    <div className="text-3xl font-bold text-primary">6</div>
                    <div className="text-xs text-slate-500 mt-1 font-medium">Meeting Tools</div>
                </div>
                <div className="bg-card rounded-2xl border border-border p-5 text-center shadow-sm">
                    <div className="text-3xl font-bold text-primary">8</div>
                    <div className="text-xs text-slate-500 mt-1 font-medium">Meeting Roles</div>
                </div>
                <div className="bg-card rounded-2xl border border-border p-5 text-center shadow-sm">
                    <div className="text-3xl font-bold text-primary">15</div>
                    <div className="text-xs text-slate-500 mt-1 font-medium">Pathways Speeches</div>
                </div>
                <div className="bg-card rounded-2xl border border-border p-5 text-center shadow-sm">
                    <div className="text-3xl font-bold text-primary">∞</div>
                    <div className="text-xs text-slate-500 mt-1 font-medium">Members Tracked</div>
                </div>
            </div>

            <div>
                <div className="flex items-center gap-4 mb-6">
                    <div>
                        <h2 className="text-2xl font-bold text-foreground tracking-tight">Meeting Tools</h2>
                        <p className="text-slate-500 text-sm mt-0.5">Click any tool to get started</p>
                    </div>
                    <div className="flex-1 h-px bg-gradient-to-r from-border to-transparent"></div>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {[<button
                        key={str(tools[i]["id"])}
                        onClick={lambda(e: MouseEvent) -> None { go(str(tools[i]["id"])); }}
                        className="card-hover group text-left bg-card rounded-2xl border border-border p-5 shadow-sm hover:border-primary/30 hover:shadow-md transition-all duration-200"
                    >
                        <div className="flex items-start justify-between gap-4">
                            <div className="flex items-start gap-4">
                                <div className={"size-12 rounded-xl flex items-center justify-center shrink-0 " + icon_bg(str(tools[i]["color"]))}>
                                    {str(tools[i]["icon"]) == "timer" and <HugeiconsIcon icon={Timer01Icon} strokeWidth={1.5} className="size-6" />}
                                    {str(tools[i]["icon"]) == "calc" and <HugeiconsIcon icon={Calculator01Icon} strokeWidth={1.5} className="size-6" />}
                                    {str(tools[i]["icon"]) == "book" and <HugeiconsIcon icon={Book01Icon} strokeWidth={1.5} className="size-6" />}
                                    {str(tools[i]["icon"]) == "mic" and <HugeiconsIcon icon={Mic01Icon} strokeWidth={1.5} className="size-6" />}
                                    {str(tools[i]["icon"]) == "calendar" and <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={1.5} className="size-6" />}
                                    {str(tools[i]["icon"]) == "trophy" and <HugeiconsIcon icon={ChampionIcon} strokeWidth={1.5} className="size-6" />}
                                </div>
                                <div className="flex flex-col gap-1.5 min-w-0">
                                    <div className="flex items-center gap-2 flex-wrap">
                                        <span className="font-semibold text-foreground">{str(tools[i]["title"])}</span>
                                        <span className={"text-xs font-medium px-2 py-0.5 rounded-full border " + badge_cls(str(tools[i]["badge"]))}>
                                            {str(tools[i]["badge"])}
                                        </span>
                                    </div>
                                    <span className="text-sm text-muted-foreground leading-relaxed">{str(tools[i]["desc"])}</span>
                                </div>
                            </div>
                            <div className="size-8 rounded-lg bg-muted flex items-center justify-center shrink-0 group-hover:bg-primary group-hover:text-primary-foreground transition-colors">
                                <HugeiconsIcon icon={ArrowRight01Icon} strokeWidth={2} className="size-4" />
                            </div>
                        </div>
                    </button> for i in range(len(tools))]}
                </div>
            </div>

            <div>
                <div className="flex items-center gap-4 mb-6">
                    <div>
                        <h2 className="text-2xl font-bold text-foreground tracking-tight">Meeting Roles</h2>
                        <p className="text-slate-500 text-sm mt-0.5">Quick reference for all roles</p>
                    </div>
                    <div className="flex-1 h-px bg-gradient-to-r from-border to-transparent"></div>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    {[<div key={str(i)} className={"flex items-start gap-4 p-4 rounded-xl border transition-colors " + role_cls(str(roles[i]["type"]))}>
                        <div className="size-10 rounded-xl bg-white flex items-center justify-center text-xl shrink-0 shadow-sm border border-border/50">
                            {str(roles[i]["emoji"])}
                        </div>
                        <div className="flex flex-col gap-0.5">
                            <span className="font-semibold text-sm text-foreground">{str(roles[i]["name"])}</span>
                            <span className="text-xs text-muted-foreground leading-relaxed">{str(roles[i]["desc"])}</span>
                        </div>
                    </div> for i in range(len(roles))]}
                </div>
            </div>

            <div className="relative overflow-hidden rounded-2xl hero-gradient p-8 text-center">
                <div className="absolute top-0 right-0 w-64 h-64 bg-amber-400/10 rounded-full -translate-y-1/2 translate-x-1/4"></div>
                <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full translate-y-1/2 -translate-x-1/4"></div>
                <div className="relative flex flex-col items-center gap-4">
                    <div className="size-14 rounded-2xl bg-amber-400 flex items-center justify-center text-amber-950 shadow-lg shadow-amber-400/30">
                        <HugeiconsIcon icon={Mic01Icon} strokeWidth={1.5} className="size-7" />
                    </div>
                    <div>
                        <h3 className="text-xl font-bold text-white">Ready to run your meeting?</h3>
                        <p className="text-white/70 text-sm mt-1">Start with the Timer or jump straight to planning</p>
                    </div>
                    <div className="flex flex-wrap justify-center gap-3">
                        <button
                            onClick={lambda(e: MouseEvent) -> None { go("timer"); }}
                            className="flex items-center gap-2 px-5 py-2.5 bg-amber-400 text-amber-950 rounded-xl font-semibold text-sm hover:bg-amber-300 transition-colors shadow-lg shadow-amber-400/30"
                        >
                            <HugeiconsIcon icon={Timer01Icon} strokeWidth={2} className="size-4" />
                            Open Timer
                        </button>
                        <button
                            onClick={lambda(e: MouseEvent) -> None { go("planner"); }}
                            className="flex items-center gap-2 px-5 py-2.5 bg-white/10 text-white rounded-xl font-semibold text-sm hover:bg-white/20 transition-colors border border-white/20"
                        >
                            <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={2} className="size-4" />
                            Plan Meeting
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>;
}
