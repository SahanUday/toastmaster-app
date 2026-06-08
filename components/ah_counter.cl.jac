import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { Calculator01Icon, UserAdd01Icon, Delete01Icon, RefreshIcon, ChartBarLineIcon }

glob FILLER_WORDS: list = ["Um", "Ah", "Like", "You know", "So", "Basically", "Actually", "Right", "Okay"];
glob WORD_COLORS: list = ["bg-blue-100 text-blue-800 border-blue-200 hover:bg-blue-200", "bg-purple-100 text-purple-800 border-purple-200 hover:bg-purple-200", "bg-rose-100 text-rose-800 border-rose-200 hover:bg-rose-200", "bg-amber-100 text-amber-800 border-amber-200 hover:bg-amber-200", "bg-emerald-100 text-emerald-800 border-emerald-200 hover:bg-emerald-200", "bg-cyan-100 text-cyan-800 border-cyan-200 hover:bg-cyan-200", "bg-indigo-100 text-indigo-800 border-indigo-200 hover:bg-indigo-200", "bg-pink-100 text-pink-800 border-pink-200 hover:bg-pink-200", "bg-teal-100 text-teal-800 border-teal-200 hover:bg-teal-200"];
glob ah_ref: dict = {"speakers": []};

def:pub AhCounter() -> JsxElement {
    has speakers: list = [];
    has new_name: str = "";
    has show_report: bool = False;

    async can with entry {
        saved: any = localStorage.getItem("tm_ah_counter");
        if saved {
            parsed: any = JSON.parse(str(saved));
            ah_ref["speakers"] = list(parsed);
            speakers = list(parsed);
        }
    }

    def save_storage() -> None {
        localStorage.setItem("tm_ah_counter", JSON.stringify(ah_ref["speakers"]));
    }

    def handle_name_change(e: ChangeEvent) -> None {
        new_name = e.target.value;
    }

    def do_add_speaker() -> None {
        if new_name {
            counts: dict = {};
            for i in range(len(FILLER_WORDS)) {
                counts[FILLER_WORDS[i]] = 0;
            }
            speaker: dict = {"name": new_name, "counts": counts};
            updated: list = speakers + [speaker];
            ah_ref["speakers"] = updated;
            speakers = updated;
            new_name = "";
            save_storage();
        }
    }

    def handle_add(e: MouseEvent) -> None {
        do_add_speaker();
    }

    def handle_key_down(e: KeyboardEvent) -> None {
        if e.key == "Enter" {
            do_add_speaker();
        }
    }

    def handle_increment(speaker_idx: int, word: str) -> None {
        updated: list = [];
        for i in range(len(speakers)) {
            s: any = speakers[i];
            if i == speaker_idx {
                new_counts: dict = {};
                for j in range(len(FILLER_WORDS)) {
                    w: any = FILLER_WORDS[j];
                    new_counts[w] = int(s["counts"][w]);
                }
                new_counts[word] = int(new_counts[word]) + 1;
                updated = updated + [{"name": s["name"], "counts": new_counts}];
            } else {
                updated = updated + [s];
            }
        }
        ah_ref["speakers"] = updated;
        speakers = updated;
        save_storage();
    }

    def handle_remove(idx: int) -> None {
        updated: list = [];
        for i in range(len(speakers)) {
            if i != idx {
                updated = updated + [speakers[i]];
            }
        }
        ah_ref["speakers"] = updated;
        speakers = updated;
        save_storage();
    }

    def handle_reset(e: MouseEvent) -> None {
        ah_ref["speakers"] = [];
        speakers = [];
        show_report = False;
        localStorage.removeItem("tm_ah_counter");
    }

    def handle_toggle_report(e: MouseEvent) -> None {
        show_report = not show_report;
    }

    def get_total(s: any) -> int {
        total: int = 0;
        for i in range(len(FILLER_WORDS)) {
            total = total + int(s["counts"][FILLER_WORDS[i]]);
        }
        return total;
    }

    def avatar_color(idx: int) -> str {
        colors: list = ["bg-blue-500", "bg-purple-500", "bg-rose-500", "bg-amber-500", "bg-emerald-500", "bg-cyan-500"];
        return str(colors[idx % len(colors)]);
    }

    has_speakers: bool = len(speakers) > 0;
    report_btn_label: str = "Hide Report" if show_report else "View Report";

    return <div className="min-h-screen bg-background">
        <div className="relative overflow-hidden hero-gradient px-6 py-10 md:py-14">
            <div className="absolute inset-0 opacity-10">
                <div className="absolute top-4 right-10 size-32 rounded-full bg-purple-400/30 blur-2xl"></div>
            </div>
            <div className="relative max-w-3xl mx-auto flex items-center gap-4">
                <div className="size-12 rounded-2xl bg-purple-500 flex items-center justify-center text-white shadow-lg shadow-purple-500/40">
                    <HugeiconsIcon icon={Calculator01Icon} strokeWidth={1.5} className="size-6" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-white">Ah-Counter</h1>
                    <p className="text-white/60 text-sm">Track filler words for each speaker</p>
                </div>
                {has_speakers and <div className="ml-auto flex items-center gap-2 bg-white/10 border border-white/20 rounded-xl px-3 py-1.5">
                    <span className="text-white/70 text-xs">Speakers:</span>
                    <span className="text-white font-bold text-sm">{str(len(speakers))}</span>
                </div>}
            </div>
        </div>

        <div className="max-w-3xl mx-auto px-4 py-8 flex flex-col gap-6">
            <div className="bg-card rounded-2xl border border-border p-5 shadow-sm">
                <h3 className="font-semibold text-sm text-foreground mb-3">Add Speaker</h3>
                <div className="flex gap-3">
                    <Input
                        value={new_name}
                        onChange={handle_name_change}
                        onKeyDown={handle_key_down}
                        placeholder="Enter speaker name..."
                        className="flex-1"
                    />
                    <button
                        onClick={handle_add}
                        className="flex items-center gap-2 px-4 py-2 bg-primary text-primary-foreground rounded-xl font-semibold text-sm hover:bg-primary/90 transition-colors shadow-sm"
                    >
                        <HugeiconsIcon icon={UserAdd01Icon} strokeWidth={2} className="size-4" />
                        Add
                    </button>
                </div>
            </div>

            {not has_speakers and <div className="bg-card rounded-2xl border border-dashed border-border p-16 text-center flex flex-col items-center gap-3">
                <div className="size-16 rounded-2xl bg-purple-500/10 flex items-center justify-center">
                    <HugeiconsIcon icon={Calculator01Icon} strokeWidth={1} className="size-8 text-purple-500" />
                </div>
                <p className="font-semibold text-foreground">No speakers yet</p>
                <p className="text-sm text-muted-foreground">Add a speaker above to start tracking filler words</p>
            </div>}

            {[<div key={str(i)} className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                <div className="flex items-center justify-between px-5 py-4 border-b border-border bg-muted/30">
                    <div className="flex items-center gap-3">
                        <div className={"size-10 rounded-full flex items-center justify-center font-bold text-white text-sm shadow-sm " + avatar_color(i)}>
                            {str(speakers[i]["name"])[0].upper()}
                        </div>
                        <div>
                            <div className="font-semibold text-foreground">{str(speakers[i]["name"])}</div>
                            <div className="text-xs text-muted-foreground">{"Total: " + str(get_total(speakers[i])) + " filler words"}</div>
                        </div>
                    </div>
                    <div className="flex items-center gap-3">
                        <div className="flex items-center gap-1.5 bg-primary/10 text-primary rounded-xl px-3 py-1">
                            <span className="font-black text-lg">{str(get_total(speakers[i]))}</span>
                            <span className="text-xs font-medium opacity-70">total</span>
                        </div>
                        <button
                            onClick={lambda(e: MouseEvent) -> None { handle_remove(i); }}
                            className="size-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                        >
                            <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-4" />
                        </button>
                    </div>
                </div>
                <div className="p-5">
                    <div className="flex flex-wrap gap-2">
                        {[<button
                            key={str(FILLER_WORDS[j])}
                            onClick={lambda(e: MouseEvent) -> None { handle_increment(i, str(FILLER_WORDS[j])); }}
                            className={"flex items-center gap-2 px-3 py-2 rounded-xl border text-sm font-medium transition-all active:scale-95 " + str(WORD_COLORS[j % len(WORD_COLORS)])}
                        >
                            <span>{str(FILLER_WORDS[j])}</span>
                            {int(speakers[i]["counts"][FILLER_WORDS[j]]) > 0 and <span className="size-5 rounded-full bg-white/60 flex items-center justify-center text-xs font-black">
                                {str(int(speakers[i]["counts"][FILLER_WORDS[j]]))}
                            </span>}
                        </button> for j in range(len(FILLER_WORDS))]}
                    </div>
                </div>
            </div> for i in range(len(speakers))]}

            {has_speakers and <div className="flex justify-center gap-3">
                <button
                    onClick={handle_toggle_report}
                    className="flex items-center gap-2 px-5 py-2.5 bg-card border border-border hover:bg-muted text-foreground rounded-xl font-semibold text-sm transition-colors"
                >
                    <HugeiconsIcon icon={ChartBarLineIcon} strokeWidth={2} className="size-4" />
                    {report_btn_label}
                </button>
                <button
                    onClick={handle_reset}
                    className="flex items-center gap-2 px-5 py-2.5 bg-card border border-destructive/30 hover:bg-destructive/5 text-destructive rounded-xl font-semibold text-sm transition-colors"
                >
                    <HugeiconsIcon icon={RefreshIcon} strokeWidth={2} className="size-4" />
                    Reset All
                </button>
            </div>}

            {show_report and <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                <div className="px-5 py-4 border-b border-border bg-muted/30">
                    <h3 className="font-semibold text-foreground">Meeting Report</h3>
                    <p className="text-xs text-muted-foreground mt-0.5">Summary of filler word usage</p>
                </div>
                <div className="p-5 flex flex-col gap-5">
                    {[<div key={"r" + str(i)} className="flex flex-col gap-3">
                        <div className="flex items-center justify-between">
                            <div className="flex items-center gap-2">
                                <div className={"size-7 rounded-full flex items-center justify-center font-bold text-white text-xs " + avatar_color(i)}>
                                    {str(speakers[i]["name"])[0].upper()}
                                </div>
                                <span className="font-semibold text-sm">{str(speakers[i]["name"])}</span>
                            </div>
                            <span className="text-sm font-bold text-primary">{"Total: " + str(get_total(speakers[i]))}</span>
                        </div>
                        <div className="flex flex-wrap gap-2">
                            {[<span
                                key={"rw" + str(j)}
                                className={"text-xs font-semibold px-2.5 py-1 rounded-lg border " + ("bg-destructive/10 border-destructive/30 text-destructive" if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 3 else "bg-muted border-border text-muted-foreground")}
                            >
                                {str(FILLER_WORDS[j]) + " × " + str(int(speakers[i]["counts"][FILLER_WORDS[j]]))}
                            </span> for j in range(len(FILLER_WORDS)) if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 0]}
                        </div>
                        {i < len(speakers) - 1 and <div className="h-px bg-border"></div>}
                    </div> for i in range(len(speakers))]}
                </div>
            </div>}
        </div>
    </div>;
}
