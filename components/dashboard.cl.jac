import from ..lib.utils { cn }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.badge { Badge }
import from .ui.button { Button }
import from .ui.separator { Separator }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { Timer01Icon, Calculator01Icon, Book01Icon, Mic01Icon, CalendarAdd01Icon, Trophy01Icon, ArrowRight01Icon }

def:pub Dashboard(onNavigate: Any) -> JsxElement {
    def go(page: str) -> None {
        if onNavigate {
            onNavigate(page);
        }
    }

    tools: list = [
        {"id": "timer", "icon": "timer", "title": "Timer", "desc": "Track speech times with green/yellow/red signals", "badge": "In-Session"},
        {"id": "ah-counter", "icon": "calc", "title": "Ah-Counter", "desc": "Count filler words per speaker", "badge": "In-Session"},
        {"id": "grammarian", "icon": "book", "title": "Grammarian", "desc": "Word of the Day + grammar notes", "badge": "In-Session"},
        {"id": "table-topics", "icon": "mic", "title": "Table Topics", "desc": "Track impromptu speakers and times", "badge": "In-Session"},
        {"id": "planner", "icon": "calendar", "title": "Meeting Planner", "desc": "Schedule meetings and assign roles", "badge": "Planning"},
        {"id": "progress", "icon": "trophy", "title": "Member Progress", "desc": "Track Pathways speech completions", "badge": "Club"}
    ];

    roles: list = [
        {"icon": "🎙️", "name": "Toastmaster of the Day", "desc": "Runs the entire meeting"},
        {"icon": "⏱️", "name": "Timer", "desc": "Tracks speech times"},
        {"icon": "🔢", "name": "Ah-Counter", "desc": "Counts filler words"},
        {"icon": "📝", "name": "Grammarian", "desc": "Word of the Day + grammar"},
        {"icon": "🗣️", "name": "Table Topics Master", "desc": "Runs impromptu speaking"},
        {"icon": "🔍", "name": "General Evaluator", "desc": "Evaluates the whole meeting"},
        {"icon": "💬", "name": "Speech Evaluator", "desc": "Evaluates prepared speeches"},
        {"icon": "🚪", "name": "Sergeant at Arms", "desc": "Setup & welcomes guests"}
    ];

    return <div className="min-h-screen bg-background">
        <div className="relative overflow-hidden bg-primary px-6 py-16 md:py-24">
            <div className="max-w-4xl mx-auto text-center flex flex-col gap-4">
                <div className="text-6xl mb-2">🎤</div>
                <h1 className="text-4xl md:text-5xl font-bold text-primary-foreground">JaseciLabs TM Manager</h1>
                <p className="text-primary-foreground/80 text-lg max-w-xl mx-auto">Your complete Toastmasters meeting toolkit — from timing speeches to tracking member progress.</p>
                <div className="flex justify-center gap-3 mt-2">
                    <Badge className="bg-primary-foreground/20 text-primary-foreground border-primary-foreground/30 text-sm px-3 py-1">JaseciLabs Club</Badge>
                    <Badge className="bg-primary-foreground/20 text-primary-foreground border-primary-foreground/30 text-sm px-3 py-1">6 Tools</Badge>
                </div>
            </div>
        </div>

        <div className="max-w-4xl mx-auto px-4 py-10 flex flex-col gap-10">
            <div>
                <div className="flex items-center gap-3 mb-6">
                    <h2 className="text-xl font-semibold">Meeting Tools</h2>
                    <Separator className="flex-1" />
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {[<Card key={str(tools[i]["id"])} className="cursor-pointer hover:shadow-md transition-shadow group">
                        <CardContent className="p-5">
                            <div className="flex items-start justify-between gap-4">
                                <div className="flex items-start gap-4">
                                    <div className="size-12 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
                                        {str(tools[i]["icon"]) == "timer" and <HugeiconsIcon icon={Timer01Icon} strokeWidth={1.5} className="size-6 text-primary" />}
                                        {str(tools[i]["icon"]) == "calc" and <HugeiconsIcon icon={Calculator01Icon} strokeWidth={1.5} className="size-6 text-primary" />}
                                        {str(tools[i]["icon"]) == "book" and <HugeiconsIcon icon={Book01Icon} strokeWidth={1.5} className="size-6 text-primary" />}
                                        {str(tools[i]["icon"]) == "mic" and <HugeiconsIcon icon={Mic01Icon} strokeWidth={1.5} className="size-6 text-primary" />}
                                        {str(tools[i]["icon"]) == "calendar" and <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={1.5} className="size-6 text-primary" />}
                                        {str(tools[i]["icon"]) == "trophy" and <HugeiconsIcon icon={Trophy01Icon} strokeWidth={1.5} className="size-6 text-primary" />}
                                    </div>
                                    <div className="flex flex-col gap-1">
                                        <div className="flex items-center gap-2">
                                            <span className="font-semibold text-foreground">{str(tools[i]["title"])}</span>
                                            <Badge variant="secondary" className="text-xs">{str(tools[i]["badge"])}</Badge>
                                        </div>
                                        <span className="text-sm text-muted-foreground">{str(tools[i]["desc"])}</span>
                                    </div>
                                </div>
                                <Button
                                    variant="ghost"
                                    size="icon-sm"
                                    onClick={lambda(e: MouseEvent) -> None { go(str(tools[i]["id"])); }}
                                    className="shrink-0 group-hover:bg-primary/10 group-hover:text-primary transition-colors"
                                >
                                    <HugeiconsIcon icon={ArrowRight01Icon} strokeWidth={2} className="size-4" />
                                </Button>
                            </div>
                        </CardContent>
                    </Card> for i in range(len(tools))]}
                </div>
            </div>

            <div>
                <div className="flex items-center gap-3 mb-6">
                    <h2 className="text-xl font-semibold">Meeting Roles Reference</h2>
                    <Separator className="flex-1" />
                </div>
                <Card>
                    <CardContent className="p-0">
                        {[<div key={str(i)} className={cn(["flex items-start gap-4 p-4",
                            "border-b border-border" if i < len(roles) - 1 else ""
                        ])}>
                            <span className="text-2xl shrink-0">{str(roles[i]["icon"])}</span>
                            <div className="flex flex-col gap-0.5">
                                <span className="font-medium text-sm">{str(roles[i]["name"])}</span>
                                <span className="text-xs text-muted-foreground">{str(roles[i]["desc"])}</span>
                            </div>
                        </div> for i in range(len(roles))]}
                    </CardContent>
                </Card>
            </div>
        </div>
    </div>;
}
