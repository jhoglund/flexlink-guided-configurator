// Debug grid bootstrap (development only)
const TOTAL_COLS = 24;

function readVarPx(name) {
    const root = getComputedStyle(document.documentElement);
    let val = (root.getPropertyValue(name) || '').trim();
    if (!val) {
        const cs = getComputedStyle(document.body);
        val = (cs.getPropertyValue(name) || '').trim();
    }
    if (!val) return 0;
    if (val.endsWith('rem')) {
        const rootPx = parseFloat(getComputedStyle(document.documentElement).fontSize) || 16;
        return parseFloat(val) * rootPx;
    }
    if (val.endsWith('px')) {
        return parseFloat(val);
    }
    // Fallback for unitless values
    return parseFloat(val) || 0;
}

function buildNumbers() {
    const nums = document.getElementById('debug-grid-numbers');
    if (!nums) return;
    // Prefer responsive vars from :root, fallback to debug-specific
    const col = (readVarPx('--col') || readVarPx('--dbg-col') || 40);
    const gutter = (readVarPx('--gutter') || readVarPx('--dbg-gutter') || 24);
    const cycle = col + gutter;
    const cols = parseInt(getComputedStyle(document.documentElement).getPropertyValue('--cols')) || TOTAL_COLS;
    const width = (readVarPx('--grid-width') || readVarPx('--dbg-width') || (col * cols + gutter * (cols - 1)));
    nums.style.width = width + 'px';
    nums.innerHTML = '';
    for (let i = 0; i < cols; i++) {
        const span = document.createElement('span');
        span.className = 'num';
        span.textContent = String(i + 1);
        // center label over each column
        span.style.left = (i * cycle + col / 2) + 'px';
        nums.appendChild(span);
    }
}

function ensureInfoLine(id, label) {
    const info = document.getElementById('debug-grid-info');
    if (!info) return null;
    let el = document.getElementById(id);
    if (!el) {
        el = document.createElement('p');
        el.id = id;
        info.appendChild(el);
    }
    if (label) el.dataset.label = label;
    return el;
}

function updateInfo() {
    const info = document.getElementById('debug-grid-info');
    if (!info) return;
    const canvas = Math.round(window.innerWidth);
    const cols = parseInt(getComputedStyle(document.documentElement).getPropertyValue('--cols')) || TOTAL_COLS;
    const overlayWidth = Math.round((readVarPx('--grid-width') || readVarPx('--dbg-width') || 0));
    const containerEl = document.querySelector('.grid-container') || document.querySelector('.container') || document.body;
    const container = Math.round(containerEl.getBoundingClientRect().width);
    const lineCanvas = ensureInfoLine('dbg-canvas-size');
    const lineContainer = ensureInfoLine('dbg-container-size');
    const lineOverlay = ensureInfoLine('dbg-overlay-size');
    const lineCols = ensureInfoLine('dbg-cols');
    const gridCountEl = document.getElementById('dbg-grid-count');
    if (lineCanvas) lineCanvas.textContent = `Canvas: ${canvas}px`;
    if (lineContainer) lineContainer.textContent = `Container: ${container}px`;
    if (overlayWidth && lineOverlay) lineOverlay.textContent = `Overlay: ${overlayWidth}px`;
    if (lineCols) lineCols.textContent = `Columns: ${cols}`;
    if (gridCountEl) gridCountEl.textContent = `Grid: ${cols} columns`;
}

export function enableDebugGrid() {
    const body = document.body;
    const btn = document.getElementById('debug-grid-toggle');
    const info = document.getElementById('debug-grid-info');
    body.classList.add('debug-grid');
    if (btn) { btn.textContent = 'HIDE'; btn.classList.add('active'); }
    if (info) info.style.display = 'block';
    buildNumbers();
    window.addEventListener('resize', buildNumbers);
}

export function toggleDebugGrid() {
    const body = document.body;
    const btn = document.getElementById('debug-grid-toggle');
    const info = document.getElementById('debug-grid-info');
    const nums = document.getElementById('debug-grid-numbers');
    const active = body.classList.toggle('debug-grid');
    if (btn) btn.textContent = active ? 'HIDE' : 'GRID';
    if (info) info.style.display = active ? 'block' : 'none';
    if (nums) nums.style.display = active ? 'block' : 'none';
    if (active) buildNumbers();
}

document.addEventListener('DOMContentLoaded', () => {
    const btn = document.getElementById('debug-grid-toggle');
    if (btn) btn.addEventListener('click', toggleDebugGrid);
    // Only auto-enable when containers exist; otherwise leave off
    if (document.getElementById('debug-grid-numbers')) {
        enableDebugGrid();
    }
    updateInfo();
    document.addEventListener('keydown', (e) => {
        if (e.key === 'g' || e.key === 'G') {
            e.preventDefault();
            toggleDebugGrid();
        }
    });
    window.addEventListener('resize', () => {
        updateInfo();
        if (document.body.classList.contains('debug-grid')) buildNumbers();
    });
});


