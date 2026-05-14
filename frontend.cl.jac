import from .components.counter { Counter }
import ".styles.global.css";

def:pub app() -> JsxElement {
    return <div className="min-h-screen bg-background text-foreground flex flex-col items-center justify-center">
        <div className="text-center space-y-6">
            <div className="text-6xl">⚡</div>
            <h1 className="text-4xl font-bold tracking-tight">Jac + Vite</h1>
            <p className="text-muted-foreground text-lg">Edit <code className="bg-muted px-2 py-1 rounded text-sm font-mono">main.jac</code> and save to get started</p>
            <div className="pt-4">
                <Counter />
            </div>
        </div>
    </div>;
}

