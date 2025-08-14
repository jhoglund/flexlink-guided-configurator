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

function clamp(val, min, max) { return Math.max(min, Math.min(max, val)); }

function measureGrid() {
    // Resolve grid content width from CSS var when available
    let gridWidth = readVarPx('--grid-width');
    if (!gridWidth) {
        const containerEl = document.querySelector('.grid-container') || document.querySelector('.container') || document.body;
        const rect = containerEl.getBoundingClientRect();
        const cs = getComputedStyle(containerEl);
        const padL = parseFloat(cs.paddingLeft) || 0;
        const padR = parseFloat(cs.paddingRight) || 0;
        gridWidth = Math.max(0, Math.round(rect.width - padL - padR));
        var gridLeft = Math.round(rect.left + padL);
    }
    // Try CSS --cols, else derive from thresholds on content width
    let cols = parseInt(getComputedStyle(document.documentElement).getPropertyValue('--cols')) || 0;
    if (!cols) {
        if (gridWidth >= 1172) cols = 24; else if (gridWidth >= 580) cols = 12; else if (gridWidth >= 284) cols = 6; else cols = 3;
    }
    // Prefer CSS variables for gutter/col so we mirror exact overlay values
    let gutter = readVarPx('--gutter');
    if (!gutter) {
        gutter = cols >= 12 ? clamp((gridWidth - 62 * cols) / (cols - 1), 12, 24) : 12;
    }
    let col = readVarPx('--col');
    if (!col) col = (gridWidth - (cols - 1) * gutter) / cols;
    return { gridWidth, cols, gutter, col };
}

function buildNumbers() {
    const nums = document.getElementById('debug-grid-numbers');
    if (!nums) return;
    const { gridWidth: width, gridLeft, cols, gutter, col } = measureGrid();
    const cycle = col + gutter;
    // Align number strip to overlay start (left) to avoid margin centering drift
    nums.style.width = width + 'px';
    const left = (typeof gridLeft === 'number') ? gridLeft : Math.round((window.innerWidth - width) / 2);
    nums.style.left = left + 'px';
    nums.style.transform = 'none';
    // Use CSS grid cells that line up with overlay columns
    nums.style.display = 'grid';
    nums.style.gridTemplateColumns = `repeat(${cols}, ${col}px)`;
    nums.style.columnGap = `${gutter}px`;
    nums.innerHTML = '';
    for (let i = 0; i < cols; i++) {
        const span = document.createElement('span');
        span.className = 'num';
        span.textContent = String(i + 1);
        span.style.width = col + 'px';
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
    const { gridWidth: container, cols } = measureGrid();
    const overlayWidth = container;
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


