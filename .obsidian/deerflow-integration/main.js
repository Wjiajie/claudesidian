var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// main.ts
var main_exports = {};
__export(main_exports, {
  default: () => DeerFlowPlugin
});
module.exports = __toCommonJS(main_exports);
var import_obsidian = require("obsidian");
var DeerFlowPlugin = class extends import_obsidian.Plugin {
  config;
  async onload() {
    await this.loadConfig();
    this.registerSettingTab();
    this.addRibbonIcon();
    this.registerCommands();
  }
  // 加载配置
  async loadConfig() {
    this.config = Object.assign({
      apiUrl: "http://localhost:8000",
      ttsEnabled: true
    }, await this.loadData());
  }
  // 保存配置
  async saveConfig() {
    await this.saveData(this.config);
  }
  // 注册设置面板（重命名避免与父类方法冲突）
  registerSettingTab() {
    this.addSettingTab(new class extends import_obsidian.PluginSettingTab {
      // 直接使用导入的 PluginSettingTab
      constructor(plugin) {
        super(plugin.app, plugin);
        this.plugin = plugin;
      }
      display() {
        const { containerEl } = this;
        containerEl.empty();
        new import_obsidian.Setting(containerEl).setName("DeerFlow \u540E\u7AEF\u5730\u5740").setDesc("\u8BF7\u8F93\u5165DeerFlow API\u670D\u52A1\u5730\u5740\uFF08\u9ED8\u8BA4\uFF1Ahttp://localhost:8000\uFF09").addText((text) => text.setPlaceholder("http://localhost:8000").setValue(this.plugin.config.apiUrl).onChange(async (value) => {
          this.plugin.config.apiUrl = value;
          await this.plugin.saveConfig();
        }));
        new import_obsidian.Setting(containerEl).setName("\u542F\u7528\u6587\u672C\u8F6C\u8BED\u97F3").setDesc("\u662F\u5426\u542F\u7528TTS\u8BED\u97F3\u5408\u6210\u529F\u80FD").addToggle((toggle) => toggle.setValue(this.plugin.config.ttsEnabled).onChange(async (value) => {
          this.plugin.config.ttsEnabled = value;
          await this.plugin.saveConfig();
        }));
      }
    }(this));
  }
  // 添加功能按钮（重命名避免与父类方法冲突）
  registerRibbonIcon() {
    this.addRibbonIcon("brain", "DeerFlow \u804A\u5929", async () => {
      class InputModal extends import_obsidian.Modal {
        constructor(app, promptText) {
          super(app);
          this.promptText = promptText;
        }
        result = null;
        onOpen() {
          const { contentEl } = this;
          contentEl.createEl("p", { text: this.promptText });
          const input = contentEl.createEl("input", { type: "text" });
          input.focus();
          contentEl.createEl("div", { cls: "modal-button-container" }, (btnContainer) => {
            btnContainer.createEl("button", { text: "\u786E\u8BA4" }, (btn) => {
              btn.onclick = () => {
                this.result = input.value;
                this.close();
              };
            });
            btnContainer.createEl("button", { text: "\u53D6\u6D88" }, (btn) => {
              btn.onclick = () => {
                this.result = null;
                this.close();
              };
            });
          });
        }
        onClose() {
          this.contentEl.empty();
        }
      }
      const modal = new InputModal(this.app, "\u8BF7\u8F93\u5165\u7814\u7A76\u95EE\u9898\uFF1A");
      modal.open();
      const prompt = await new Promise((resolve) => {
        modal.onClose = () => resolve(modal.result);
      });
      if (!prompt)
        return;
      try {
        const response = await this.callChatApi(prompt);
        new import_obsidian.Notice("\u7814\u7A76\u7ED3\u679C\u5DF2\u751F\u6210\uFF0C\u70B9\u51FB\u67E5\u770B");
        this.insertResultToNote(response);
      } catch (error) {
        new import_obsidian.Notice(`\u8BF7\u6C42\u5931\u8D25\uFF1A${error.message}`);
      }
    });
  }
  async onload() {
    await this.loadConfig();
    this.registerSettingTab();
    this.registerRibbonIcon();
    this.registerCommands();
  }
  // 注册命令
  registerCommands() {
    this.addCommand({
      id: "generate-podcast",
      name: "\u751F\u6210\u64AD\u5BA2\u811A\u672C",
      callback: async () => {
        const selectedText = this.app.workspace.getActiveViewOfType(import_obsidian.MarkdownView)?.editor.getSelection();
        if (!selectedText) {
          new import_obsidian.Notice("\u8BF7\u5148\u9009\u62E9\u9700\u8981\u751F\u6210\u64AD\u5BA2\u7684\u6587\u672C");
          return;
        }
        try {
          const audio = await this.callPodcastApi(selectedText);
          this.insertAudioToNote(audio);
        } catch (error) {
          new import_obsidian.Notice(`\u64AD\u5BA2\u751F\u6210\u5931\u8D25\uFF1A${error.message}`);
        }
      }
    });
  }
  // 调用聊天API（流式响应）
  // 调用聊天API（流式响应）
  async callChatApi(prompt) {
    const threadId = uuidv4();
    const url = `${this.config.apiUrl}/api/chat/stream`;
    return new Promise((resolve, reject) => {
      let result = "";
      fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          messages: [{ role: "user", content: prompt }],
          thread_id: threadId,
          auto_accepted_plan: true
        })
      }).then((response) => {
        if (!response.ok)
          throw new Error(`HTTP\u9519\u8BEF\uFF1A${response.status}`);
        const reader = response.body?.getReader();
        if (!reader)
          throw new Error("\u54CD\u5E94\u6D41\u4E0D\u53EF\u8BFB");
        const processStream = async () => {
          while (true) {
            const { done, value } = await reader.read();
            if (done) {
              resolve(result);
              break;
            }
            const data = new TextDecoder().decode(value);
            if (data)
              result += data;
          }
        };
        processStream().catch(reject);
      }).catch(reject);
    });
  }
  // 调用播客生成API
  async callPodcastApi(content) {
    const response = await fetch(`${this.config.apiUrl}/api/podcast/generate`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ content })
    });
    if (!response.ok)
      throw new Error(`HTTP\u9519\u8BEF\uFF1A${response.status}`);
    return await response.blob();
  }
  // 将结果插入笔记
  insertResultToNote(content) {
    const editor = this.app.workspace.getActiveViewOfType(import_obsidian.MarkdownView)?.editor;
    editor?.replaceSelection(`

### DeerFlow \u7814\u7A76\u7ED3\u679C
${content}
`);
  }
  // 插入音频到笔记
  async insertAudioToNote(audioBlob) {
    const audioUrl = URL.createObjectURL(audioBlob);
    const editor = this.app.workspace.getActiveViewOfType(import_obsidian.MarkdownView)?.editor;
    editor?.replaceSelection(`

<audio controls src="${audioUrl}">\u64AD\u5BA2\u97F3\u9891</audio>
`);
  }
};
function uuidv4() {
  return ("10000000-1000-4000-8000" + -1e11).replace(
    /[018]/g,
    (c) => (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
  );
}
