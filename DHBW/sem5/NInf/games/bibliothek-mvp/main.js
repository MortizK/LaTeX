const WIDTH = 1000;
const HEIGHT = 650;
const GAME_SECONDS = 150;
const PLAYER_SPEED = 155;
const NOISE_DURATION = 900;

let game;

function distance(a, b) {
    return Phaser.Math.Distance.Between(a.x, a.y, b.x, b.y);
}

class LibraryScene extends Phaser.Scene {
    constructor() {
        super("library");
        this.state = "playing";
        this.booksFound = 0;
        this.timeLeft = GAME_SECONDS;
        this.dialogOpen = false;
        this.lastNoise = 0;
        this.audioContext = null;
        this.nextHeartbeat = 0;
        this.lastInteraction = 0;
        this.noisePosition = { x: 75, y: 350 };
        this.wallBodies = [];
    }

    create() {
        this.physics.resume();
        this.drawLibrary();
        this.createPlayer();
        this.createLibraryCollisions();
        this.createSigns();
        this.createBooks();
        this.createCharacters();
        this.createExit();
        this.createVisibility();
        this.createHud();
        this.createControls();
        this.createAudio();

        this.time.addEvent({
            delay: 1000,
            loop: true,
            callback: this.tickClock,
            callbackScope: this
        });
        this.showMessage("Finde die drei Bücher und verlasse die Bibliothek.", 4000);
    }

    drawLibrary() {
        this.add.rectangle(WIDTH / 2, HEIGHT / 2, WIDTH, HEIGHT, 0x101722);
        const graphics = this.add.graphics();
        graphics.fillStyle(0x1a2430, 1).fillRect(30, 95, 940, 510);
        graphics.lineStyle(3, 0x3b4c5b, 1).strokeRect(30, 95, 940, 510);

        // Regalreihen bilden die begehbaren Gänge.
        for (let x = 115; x <= 865; x += 150) {
            graphics.fillStyle(0x463326, 1).fillRect(x, 130, 52, 430);
            graphics.lineStyle(2, 0x785331, 1).strokeRect(x, 130, 52, 430);
            for (let y = 150; y < 550; y += 30) {
                graphics.lineStyle(1, 0xb1844c, 0.7).lineBetween(x + 5, y, x + 47, y);
            }
        }

        this.add.text(50, 38, "NACHTSCHICHT IN DER BIBLIOTHEK", {
            fontSize: "25px", color: "#d9c38a", fontStyle: "bold"
        });
        this.add.text(50, 70, "Lesesaal · Erdgeschoss", {
            fontSize: "16px", color: "#8293a6"
        });
        this.add.text(452, 112, "INFORMATIK", {
            fontSize: "13px", color: "#bdc9d6"
        }).setOrigin(0.5);
        this.add.text(752, 112, "GESELLSCHAFT", {
            fontSize: "13px", color: "#bdc9d6"
        }).setOrigin(0.5);
    }

    createPlayer() {
        this.player = this.add.container(75, 350);
        const body = this.add.circle(0, 0, 13, 0x8bd4ff);
        body.setStrokeStyle(2, 0xe8f6ff);
        this.player.add(body);
        this.player.setDepth(5);
        this.physics.add.existing(this.player);
        this.player.body.setCircle(13);
        this.player.body.setCollideWorldBounds(true);
    }

    createLibraryCollisions() {
        this.walls = this.physics.add.staticGroup();
        for (let x = 115; x <= 865; x += 150) {
            const wall = this.add.rectangle(x + 26, 345, 52, 430, 0x000000, 0)
                .setVisible(false);
            this.physics.add.existing(wall, true);
            wall.body.setSize(52, 430);
            wall.body.updateFromGameObject();
            this.walls.add(wall);
            this.wallBodies.push(wall);
        }
        // Begrenzung des begehbaren Lesesaals, damit niemand in HUD oder Randbereiche läuft.
        const boundaries = [
            { x: 500, y: 100, width: 940, height: 10 },
            { x: 500, y: 600, width: 940, height: 10 },
            { x: 35, y: 350, width: 10, height: 500 },
            { x: 965, y: 350, width: 10, height: 500 }
        ];
        boundaries.forEach(({ x, y, width, height }) => {
            const boundary = this.add.rectangle(x, y, width, height, 0x000000, 0)
                .setVisible(false);
            this.physics.add.existing(boundary, true);
            boundary.body.setSize(width, height);
            boundary.body.updateFromGameObject();
            this.walls.add(boundary);
            this.wallBodies.push(boundary);
        });
        this.physics.add.collider(this.player, this.walls);
    }

    createBooks() {
        const books = [
            { x: 141, y: 195, title: "Algorithmen", section: "INF-ALG" },
            { x: 591, y: 495, title: "Netzwerke", section: "INF-NET" },
            { x: 741, y: 260, title: "Gesellschaft", section: "G-202" }
        ];
        this.books = books.map((data, index) => {
            const book = this.add.container(data.x, data.y).setDepth(4);
            const cover = this.add.rectangle(0, 0, 12, 25, [0xc8785e, 0x6f93c8, 0xc8ae58][index]);
            cover.setStrokeStyle(2, 0xf8e6b0);
            book.add(cover);
            book.setData("title", data.title);
            book.setData("section", data.section);
            book.setData("collected", false);
            return book;
        });
    }

    createSigns() {
        const signs = [
            { x: 178, y: 160, label: "INF-ALG · A–M", detail: "Informatik · Algorithmen · Autoren A bis M" },
            { x: 628, y: 530, label: "INF-NET · N–Z", detail: "Informatik · Netzwerke · Autoren N bis Z" },
            { x: 778, y: 225, label: "G-202 · SOZ", detail: "Gesellschaft · Sozialwissenschaften · Signatur G-202" }
        ];
        this.signs = signs.map(sign => {
            const marker = this.add.text(sign.x, sign.y, sign.label, {
                fontSize: "11px", color: "#f2d58b", backgroundColor: "#17202b",
                padding: { left: 4, right: 4, top: 3, bottom: 3 }
            }).setOrigin(0.5).setDepth(6);
            marker.setData("detail", sign.detail);
            return marker;
        });
    }

    createCharacters() {
        this.npcs = [
            this.makeNpc(350, 360, 0x9f7ae8, "Lerngruppe", 
                "Die Lerngruppe flüstert über einen Hinterausgang."),
            this.makeNpc(820, 360, 0xe39c62, "Pizza-Student",
                "Der Student kennt den Weg. Er möchte dafür eine Energy-Dose.")
        ];
        this.enemy = this.add.container(540, 570).setDepth(4);
        this.enemy.add(this.add.circle(0, 0, 15, 0x8d303d));
        this.enemy.add(this.add.text(0, -30, "WACHE", {
            fontSize: "11px", color: "#f2a7a7"
        }).setOrigin(0.5));
        this.physics.add.existing(this.enemy);
        this.enemy.body.setSize(30, 30).setOffset(-15, -15);
        this.enemyTarget = { x: 540, y: 570 };
        this.enemyPatrol = this.time.addEvent({
            delay: 2600, loop: true, callback: this.choosePatrolTarget, callbackScope: this
        });
        this.npcs.forEach((npc, index) => {
            npc.setData("target", { x: npc.x, y: npc.y });
            npc.setData("nextMove", this.time.now + index * 900);
            this.addWallColliders(npc);
        });
        this.addWallColliders(this.enemy);
    }

    addWallColliders(actor) {
        for (const wall of this.wallBodies) {
            this.physics.add.collider(actor, wall);
        }
    }

    makeNpc(x, y, color, name, hint) {
        const npc = this.add.container(x, y).setDepth(4);
        npc.add(this.add.circle(0, 0, 15, color).setStrokeStyle(2, 0xffffff));
        npc.add(this.add.text(0, -29, name, {
            fontSize: "12px", color: "#e5eaf1"
        }).setOrigin(0.5));
        npc.setData("name", name);
        npc.setData("hint", hint);
        this.physics.add.existing(npc);
        npc.body.setCircle(15);
        return npc;
    }

    createExit() {
        this.exit = this.add.rectangle(930, 570, 55, 45, 0x5c272d)
            .setStrokeStyle(3, 0xde6871).setDepth(2);
        this.add.text(930, 570, "AUS-\nGANG", {
            fontSize: "12px", color: "#ffd8d8", align: "center"
        }).setOrigin(0.5).setDepth(3);
    }

    createVisibility() {
        this.visibility = this.add.rectangle(WIDTH / 2, HEIGHT / 2, WIDTH, HEIGHT, 0x020409, 0.93)
            .setDepth(10);
        this.lightShape = this.make.graphics({ x: 0, y: 0, add: false });
        this.lightMask = this.lightShape.createGeometryMask();
        this.lightMask.invertAlpha = true;
        this.visibility.setMask(this.lightMask);
        this.updateVisibility();
    }

    createHud() {
        this.hud = {};
        this.hud.books = this.add.text(700, 37, "BÜCHER: 0/3", {
            fontSize: "20px", color: "#f2d58b", fontStyle: "bold"
        });
        this.hud.clock = this.add.text(880, 37, this.clockText(), {
            fontSize: "20px", color: "#f2d58b", fontStyle: "bold"
        });
        this.hud.controlsPanel = this.add.rectangle(560, 75, 225, 48, 0x111923, 0.95)
            .setStrokeStyle(1, 0x56677a).setDepth(20);
        this.hud.controls = this.add.text(560, 75,
            "WASD / Pfeile: Bewegen   SHIFT: Sprinten\nE / SPACE: Aktion   Q: Dialog schließen", {
                fontSize: "12px", color: "#d4deea", align: "center", lineSpacing: 4
            }).setOrigin(0.5).setDepth(21);
        this.hud.message = this.add.text(WIDTH / 2, 615, "", {
            fontSize: "17px", color: "#f5f0dc", backgroundColor: "#111923",
            padding: { left: 12, right: 12, top: 7, bottom: 7 },
            align: "center"
        }).setOrigin(0.5).setDepth(20);
        this.hud.books.setDepth(20);
        this.hud.clock.setDepth(20);
    }

    createControls() {
        this.keys = this.input.keyboard.addKeys("W,A,S,D,E,SHIFT,SPACE");
        this.cursors = this.input.keyboard.createCursorKeys();
        this.input.keyboard.on("keydown-E", () => this.interact());
        this.input.keyboard.on("keydown-SPACE", () => this.interact());
    }

    createAudio() {
        const AudioContext = window.AudioContext || window.webkitAudioContext;
        if (!AudioContext) return;
        this.audioContext = new AudioContext();
        this.input.keyboard.once("keydown", () => {
            if (this.audioContext.state === "suspended") this.audioContext.resume();
            this.playTone(90, 0.16, "sine", 0.04);
        });
    }

    playTone(frequency, duration, type = "sine", volume = 0.04) {
        if (!this.audioContext) return;
        const oscillator = this.audioContext.createOscillator();
        const gain = this.audioContext.createGain();
        oscillator.type = type;
        oscillator.frequency.value = frequency;
        gain.gain.setValueAtTime(volume, this.audioContext.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, this.audioContext.currentTime + duration);
        oscillator.connect(gain).connect(this.audioContext.destination);
        oscillator.start();
        oscillator.stop(this.audioContext.currentTime + duration);
    }

    update() {
        if (this.state !== "playing" || this.dialogOpen) return;
        this.movePlayer();
        this.updateCharacters();
        this.updateVisibility();
        this.collectBooks();
        this.updateEnemy();
        this.updateNoise();
        this.updateAudio();
        this.checkExit();
    }

    movePlayer() {
        const body = this.player.body;
        let x = 0;
        let y = 0;
        if (this.cursors.left.isDown || this.keys.A.isDown) x--;
        if (this.cursors.right.isDown || this.keys.D.isDown) x++;
        if (this.cursors.up.isDown || this.keys.W.isDown) y--;
        if (this.cursors.down.isDown || this.keys.S.isDown) y++;
        const running = this.keys.SHIFT.isDown;
        const speed = running ? PLAYER_SPEED * 1.55 : PLAYER_SPEED;
        const direction = new Phaser.Math.Vector2(x, y).normalize();
        body.setVelocity(direction.x * speed, direction.y * speed);
        if (running && (x !== 0 || y !== 0)) {
            this.lastNoise = this.time.now + NOISE_DURATION;
            this.noisePosition = { x: this.player.x, y: this.player.y };
        }
        this.player.setAlpha(this.isInShadow() ? 0.7 : 1);
    }

    collectBooks() {
        for (const book of this.books) {
            if (book.getData("collected") || distance(this.player, book) > 48) continue;
            if (!this.keys.E.isDown && !this.keys.SPACE.isDown) continue;
            book.setData("collected", true);
            book.setVisible(false);
            this.booksFound++;
            this.hud.books.setText(`BÜCHER: ${this.booksFound}/3`);
            this.playTone(520, 0.18, "triangle", 0.06);
            this.showMessage(`Eingesammelt: ${book.getData("title")} (${book.getData("section")})`, 1800);
            if (this.booksFound === 3) this.showMessage("Alle Bücher! Jetzt zum Ausgang im Südosten.", 3200);
        }
    }

    interact() {
        if (this.state !== "playing" || this.dialogOpen) return;
        const sign = this.signs.find(candidate => distance(this.player, candidate) < 58);
        if (sign) {
            this.showMessage(`Schild: ${sign.getData("detail")}`, 3600);
            this.playTone(260, 0.12, "sine", 0.03);
            return;
        }
        const book = this.books.find(candidate =>
            !candidate.getData("collected") && distance(this.player, candidate) < 48);
        if (book) {
            this.collectBook(book);
            return;
        }
        const npc = this.npcs.find(candidate => distance(this.player, candidate) < 55);
        if (!npc) {
            this.showMessage("Niemand in der Nähe. (E zum Interagieren)", 1400);
            return;
        }
        this.dialogOpen = true;
        const panel = this.add.rectangle(WIDTH / 2, 520, 690, 105, 0x101722, 0.96)
            .setStrokeStyle(2, 0xc1a56a).setDepth(20);
        const text = this.add.text(WIDTH / 2, 495,
            `${npc.getData("name")}: "${npc.getData("hint")}"\n[E] Nachfragen    [Q] Gespräch beenden`, {
                fontSize: "17px", color: "#f7f0dc", align: "center", lineSpacing: 10
            }).setOrigin(0.5).setDepth(21);
        const close = () => {
            panel.destroy(); text.destroy(); this.dialogOpen = false;
        };
        this.input.keyboard.once("keydown-E", close);
        this.input.keyboard.once("keydown-Q", close);
        this.showMessage("Ein Gespräch kann Aufmerksamkeit erregen.", 1800);
    }

    collectBook(book) {
        book.setData("collected", true);
        book.setVisible(false);
        this.booksFound++;
        this.hud.books.setText(`BÜCHER: ${this.booksFound}/3`);
        this.playTone(520, 0.18, "triangle", 0.06);
        this.showMessage(`Eingesammelt: ${book.getData("title")} (${book.getData("section")})`, 1800);
        if (this.booksFound === 3) this.showMessage("Alle Bücher! Jetzt zum Ausgang im Südosten.", 3200);
    }

    updateCharacters() {
        for (const npc of this.npcs) {
            const enemyDistance = distance(npc, this.enemy);
            if (enemyDistance < 175) {
                const fleeAngle = Phaser.Math.Angle.Between(this.enemy.x, this.enemy.y, npc.x, npc.y);
                npc.setData("target", {
                    x: Phaser.Math.Clamp(npc.x + Math.cos(fleeAngle) * 170, 60, 940),
                    y: Phaser.Math.Clamp(npc.y + Math.sin(fleeAngle) * 170, 135, 575)
                });
                npc.setData("nextMove", this.time.now + 900);
            } else if (this.time.now < this.lastNoise && distance(npc, this.noisePosition) < 260) {
                const noiseAngle = Phaser.Math.Angle.Between(npc.x, npc.y,
                    this.noisePosition.x, this.noisePosition.y);
                npc.setData("target", {
                    x: Phaser.Math.Clamp(npc.x + Math.cos(noiseAngle) * 130, 60, 940),
                    y: Phaser.Math.Clamp(npc.y + Math.sin(noiseAngle) * 130, 135, 575)
                });
                npc.setData("nextMove", this.time.now + 700);
            }
            if (this.time.now >= npc.getData("nextMove")) {
                npc.setData("target", {
                    x: Phaser.Math.Between(60, 940),
                    y: Phaser.Math.Between(135, 575)
                });
                npc.setData("nextMove", this.time.now + Phaser.Math.Between(1800, 3600));
            }
            const target = npc.getData("target");
            const angle = Phaser.Math.Angle.Between(npc.x, npc.y, target.x, target.y);
            const velocity = distance(npc, target) > 18 ? 25 : 0;
            npc.body.setVelocity(Math.cos(angle) * velocity, Math.sin(angle) * velocity);
            if (distance(npc, this.player) < 42) npc.setAlpha(1);
            else npc.setAlpha(this.isInShadow() ? 0.55 : 1);
        }
    }

    updateVisibility() {
        if (!this.lightShape || !this.player) return;
        this.lightShape.clear();
        this.lightShape.fillStyle(0xffffff, 1);
        this.lightShape.fillCircle(this.player.x, this.player.y, 150);
        this.lightShape.fillCircle(this.player.x, this.player.y, 75);
    }

    updateAudio() {
        if (!this.audioContext || this.time.now < this.nextHeartbeat) return;
        const proximity = distance(this.player, this.enemy);
        if (proximity < 260) {
            const urgency = Phaser.Math.Clamp((260 - proximity) / 260, 0, 1);
            this.playTone(62, 0.12, "sine", 0.025 + urgency * 0.045);
            this.nextHeartbeat = this.time.now + 720 - urgency * 420;
        } else {
            this.nextHeartbeat = this.time.now + 1200;
        }
        if (this.time.now < this.lastNoise) this.playTone(115, 0.08, "sawtooth", 0.018);
    }

    updateEnemy() {
        const target = (this.time.now < this.lastNoise || distance(this.player, this.enemy) < 125)
            ? this.player : this.enemyTarget;
        const angle = Phaser.Math.Angle.Between(this.enemy.x, this.enemy.y, target.x, target.y);
        const speed = target === this.player ? 78 : 48;
        this.enemy.body.setVelocity(Math.cos(angle) * speed, Math.sin(angle) * speed);
        if (distance(this.player, this.enemy) < 25) this.endGame("Die Wache hat dich entdeckt.");
    }

    choosePatrolTarget() {
        this.enemyTarget = {
            x: Phaser.Math.Between(60, 940),
            y: Phaser.Math.Between(135, 575)
        };
    }

    updateNoise() {
        // Sprinten macht ein hörbares Geräusch, verändert aber nicht die Beleuchtung.
    }

    checkExit() {
        if (distance(this.player, this.exit) < 48) {
            if (this.booksFound === 3) this.endGame("Du bist entkommen. Die Bibliothek schließt hinter dir.");
            else this.showMessage("Der Ausgang ist verriegelt. Finde erst alle drei Bücher.", 1800);
        }
    }

    tickClock() {
        if (this.state !== "playing") return;
        this.timeLeft--;
        this.hud.clock.setText(this.clockText());
        if (this.timeLeft <= 20) this.hud.clock.setColor("#ef7474");
        if (this.timeLeft <= 0) this.endGame("Die Türen sind verriegelt. Du bist zu spät.");
    }

    clockText() {
        const minutes = Math.floor(this.timeLeft / 60);
        const seconds = String(this.timeLeft % 60).padStart(2, "0");
        return `SCHLIESSUNG ${minutes}:${seconds}`;
    }

    isInShadow() {
        return Math.floor(this.player.x / 150) % 2 === 1;
    }

    showMessage(message, duration) {
        if (!this.hud || !this.hud.message) return;
        this.hud.message.setText(message).setVisible(true);
        this.time.delayedCall(duration, () => {
            if (this.hud.message.text === message) this.hud.message.setVisible(false);
        });
    }

    endGame(message) {
        if (this.state !== "playing") return;
        this.state = "ended";
        this.physics.pause();
        this.player.body.setVelocity(0, 0);
        this.enemy.body.setVelocity(0, 0);
        this.enemyPatrol?.remove(false);
        this.playTone(message.includes("entkommen") ? 440 : 42, 0.8, "sawtooth", 0.07);
        const overlay = this.add.rectangle(WIDTH / 2, HEIGHT / 2, WIDTH, HEIGHT, 0x05070b, 0.9).setDepth(30);
        this.add.text(WIDTH / 2, 255, message, {
            fontSize: "28px", color: "#f2d58b", align: "center", wordWrap: { width: 700 }
        }).setOrigin(0.5).setDepth(31);
        this.add.text(WIDTH / 2, 345, "R für einen neuen Versuch", {
            fontSize: "20px", color: "#e8edf5"
        }).setOrigin(0.5).setDepth(31);
        this.input.keyboard.once("keydown-R", () => this.scene.restart());
    }
}

game = new Phaser.Game({
    type: Phaser.AUTO,
    parent: "game",
    width: WIDTH,
    height: HEIGHT,
    backgroundColor: "#101722",
    physics: { default: "arcade", arcade: { debug: false } },
    scene: [LibraryScene],
    scale: { mode: Phaser.Scale.FIT, autoCenter: Phaser.Scale.CENTER_BOTH }
});
