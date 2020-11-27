"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Command = void 0;
const vscode = __importStar(require("vscode"));
const fs = __importStar(require("fs-extra"));
const latex_utensils_1 = require("latex-utensils");
const environment_1 = require("./environment");
function isTriggerSuggestNeeded(name) {
    const reg = /[a-z]*(cite|ref|input)[a-z]*|begin|bibitem|(sub)?(import|includefrom|inputfrom)|gls(?:pl|text|first|plural|firstplural|name|symbol|desc|user(?:i|ii|iii|iv|v|vi))?|Acr(?:long|full|short)?(?:pl)?|ac[slf]?p?/i;
    return reg.test(name);
}
class Command {
    constructor(extension, environment) {
        this.packages = [];
        this.bracketCmds = {};
        this.definedCmds = {};
        this.defaultCmds = [];
        this.defaultSymbols = [];
        this.packageCmds = {};
        this.extension = extension;
        this.environment = environment;
    }
    initialize(defaultCmds) {
        const snippetReplacements = vscode.workspace.getConfiguration('latex-workshop').get('intellisense.commandsJSON.replace');
        // Initialize default commands and `latex-mathsymbols`
        Object.keys(defaultCmds).forEach(key => {
            if (key in snippetReplacements) {
                const action = snippetReplacements[key];
                if (action === '') {
                    return;
                }
                defaultCmds[key].snippet = action;
            }
            else if (key === 'begin') {
                // Tweak \begin{
                const autoClosing = vscode.workspace.getConfiguration('editor').get('autoClosingBrackets');
                if (autoClosing !== 'never') {
                    defaultCmds[key].snippet = 'begin{$0}';
                }
            }
            this.defaultCmds.push(this.entryCmdToCompletion(key, defaultCmds[key]));
        });
        // Initialize default env begin-end pairs
        this.environment.getDefaultEnvs(environment_1.EnvSnippetType.AsCommand).forEach(cmd => {
            this.defaultCmds.push(cmd);
        });
        // Handle special commands with brackets
        const bracketCmds = ['(', '[', '{', 'left(', 'left[', 'left\\{'];
        this.defaultCmds.filter(cmd => bracketCmds.includes(this.getCmdName(cmd))).forEach(cmd => {
            this.bracketCmds[cmd.label.slice(1)] = cmd;
        });
    }
    provideFrom(_type, _result, args) {
        return this.provide(args.document.languageId, args.document, args.position);
    }
    provide(languageId, document, position) {
        const configuration = vscode.workspace.getConfiguration('latex-workshop');
        const useOptionalArgsEntries = configuration.get('intellisense.optionalArgsEntries.enabled');
        let range = undefined;
        if (document && position) {
            const startPos = document.lineAt(position).text.lastIndexOf('\\', position.character - 1);
            if (startPos >= 0) {
                range = new vscode.Range(position.line, startPos + 1, position.line, position.character);
            }
        }
        const suggestions = [];
        const cmdList = []; // This holds defined commands without the backslash
        // Insert default commands
        this.defaultCmds.forEach(cmd => {
            if (!useOptionalArgsEntries && this.getCmdName(cmd).includes('[')) {
                return;
            }
            cmd.range = range;
            suggestions.push(cmd);
            cmdList.push(this.getCmdName(cmd, true));
        });
        // Insert unimathsymbols
        if (configuration.get('intellisense.unimathsymbols.enabled')) {
            if (this.defaultSymbols.length === 0) {
                const symbols = JSON.parse(fs.readFileSync(`${this.extension.extensionRoot}/data/unimathsymbols.json`).toString());
                Object.keys(symbols).forEach(key => {
                    this.defaultSymbols.push(this.entryCmdToCompletion(key, symbols[key]));
                });
            }
            this.defaultSymbols.forEach(symbol => {
                suggestions.push(symbol);
                cmdList.push(this.getCmdName(symbol, true));
            });
        }
        // Insert commands from packages
        if ((configuration.get('intellisense.package.enabled'))) {
            const extraPackages = this.extension.completer.command.getExtraPkgs(languageId);
            if (extraPackages) {
                extraPackages.forEach(pkg => {
                    this.provideCmdInPkg(pkg, suggestions, cmdList);
                    this.environment.provideEnvsAsCommandInPkg(pkg, suggestions, cmdList);
                });
            }
            this.extension.manager.getIncludedTeX().forEach(tex => {
                const pkgs = this.extension.manager.cachedContent[tex].element.package;
                if (pkgs !== undefined) {
                    pkgs.forEach(pkg => {
                        this.provideCmdInPkg(pkg, suggestions, cmdList);
                        this.environment.provideEnvsAsCommandInPkg(pkg, suggestions, cmdList);
                    });
                }
            });
        }
        // Start working on commands in tex
        this.extension.manager.getIncludedTeX().forEach(tex => {
            const cmds = this.extension.manager.cachedContent[tex].element.command;
            if (cmds !== undefined) {
                cmds.forEach(cmd => {
                    if (!cmdList.includes(this.getCmdName(cmd, true))) {
                        cmd.range = range;
                        suggestions.push(cmd);
                        cmdList.push(this.getCmdName(cmd, true));
                    }
                });
            }
        });
        return suggestions;
    }
    /**
     * Surrounds `content` with a command picked in QuickPick.
     *
     * @param content A string to be surrounded. If not provided, then we loop over all the selections and surround each of them.
     */
    surround(content) {
        if (!vscode.window.activeTextEditor) {
            return;
        }
        const editor = vscode.window.activeTextEditor;
        const candidate = [];
        this.provide(editor.document.languageId).forEach(item => {
            if (item.insertText === undefined) {
                return;
            }
            if (item.label === '\\begin') { // Causing a lot of trouble
                return;
            }
            const command = (typeof item.insertText !== 'string') ? item.insertText.value : item.insertText;
            if (command.match(/(.*)(\${\d.*?})/)) {
                candidate.push(command.replace(/\n/g, '').replace(/\t/g, '').replace('\\\\', '\\'));
            }
        });
        vscode.window.showQuickPick(candidate, {
            placeHolder: 'Press ENTER to surround previous selection with selected command',
            matchOnDetail: true,
            matchOnDescription: true
        }).then(selected => {
            if (selected === undefined) {
                return;
            }
            editor.edit(editBuilder => {
                let selectedCommand = selected;
                let selectedContent = content;
                for (const selection of editor.selections) {
                    if (!content) {
                        selectedContent = editor.document.getText(selection);
                        selectedCommand = '\\' + selected;
                    }
                    editBuilder.replace(new vscode.Range(selection.start, selection.end), selectedCommand.replace(/(.*)(\${\d.*?})/, `$1${selectedContent}`) // Replace text
                        .replace(/\${\d:?(.*?)}/g, '$1') // Remove snippet placeholders
                        .replace('\\\\', '\\') // Unescape backslashes, e.g., begin{${1:env}}\n\t$2\n\\\\end{${1:env}}
                        .replace(/\$\d/, '')); // Remove $2 etc
                }
            });
        });
        return;
    }
    /**
     * Updates the Manager cache for commands used in `file` with `nodes`.
     * If `nodes` is `undefined`, `content` is parsed with regular expressions,
     * and the result is used to update the cache.
     * @param file The path of a LaTeX file.
     * @param nodes AST of a LaTeX file.
     * @param content The content of a LaTeX file.
     */
    update(file, nodes, content) {
        // Remove newcommand cmds, because they will be re-insert in the next step
        Object.keys(this.definedCmds).forEach(cmd => {
            if (this.definedCmds[cmd].file === file) {
                delete this.definedCmds[cmd];
            }
        });
        if (nodes !== undefined) {
            this.extension.manager.cachedContent[file].element.command = this.getCmdFromNodeArray(file, nodes);
        }
        else if (content !== undefined) {
            this.extension.manager.cachedContent[file].element.command = this.getCmdFromContent(file, content);
        }
    }
    /**
     * Returns the name of `item`. The backward slahsh, `\`, is removed.
     *
     * @param item A completion item.
     * @param removeArgs If `true`, returns a name without arguments.
     */
    getCmdName(item, removeArgs = false) {
        const label = item.label.startsWith('\\') ? item.label.slice(1) : item.label;
        const name = item.filterText ? item.filterText : label;
        if (removeArgs) {
            const i = name.search(/[[{]/);
            return i > -1 ? name.substr(0, i) : name;
        }
        return name;
    }
    getCmdFromNodeArray(file, nodes, cmdList = []) {
        let cmds = [];
        nodes.forEach(node => {
            cmds = cmds.concat(this.getCmdFromNode(file, node, cmdList));
        });
        return cmds;
    }
    getExtraPkgs(languageId) {
        const configuration = vscode.workspace.getConfiguration('latex-workshop');
        const extraPackages = Object.assign(configuration.get('intellisense.package.extra'));
        if (languageId === 'latex-expl3') {
            extraPackages.push('expl3');
        }
        else if (languageId === 'latex') {
            extraPackages.push('latex-document');
        }
        return extraPackages;
    }
    /**
     * Updates the Manager cache for packages used in `file` with `nodes`.
     * If `nodes` is `undefined`, `content` is parsed with regular expressions,
     * and the result is used to update the cache.
     *
     * @param file The path of a LaTeX file.
     * @param nodes AST of a LaTeX file.
     * @param content The content of a LaTeX file.
     */
    updatePkg(file, nodes, content) {
        if (nodes !== undefined) {
            this.updatePkgWithNodeArray(file, nodes);
        }
        else if (content !== undefined) {
            const pkgReg = /\\usepackage(?:\[[^[\]{}]*\])?{(.*)}/g;
            const pkgs = [];
            if (this.extension.manager.cachedContent[file].element.package === undefined) {
                this.extension.manager.cachedContent[file].element.package = [];
            }
            while (true) {
                const result = pkgReg.exec(content);
                if (result === null) {
                    break;
                }
                result[1].split(',').forEach(pkg => {
                    pkg = pkg.trim();
                    if (pkgs.includes(pkg)) {
                        return;
                    }
                    const filePkgs = this.extension.manager.cachedContent[file].element.package;
                    if (filePkgs) {
                        filePkgs.push(pkg);
                    }
                    else {
                        this.extension.manager.cachedContent[file].element.package = [pkg];
                    }
                });
            }
        }
    }
    updatePkgWithNodeArray(file, nodes) {
        nodes.forEach(node => {
            if (latex_utensils_1.latexParser.isCommand(node) && (node.name === 'usepackage' || node.name === 'documentclass')) {
                node.args.forEach(arg => {
                    if (latex_utensils_1.latexParser.isOptionalArg(arg)) {
                        return;
                    }
                    for (const c of arg.content) {
                        if (!latex_utensils_1.latexParser.isTextString(c)) {
                            continue;
                        }
                        c.content.split(',').forEach(pkg => {
                            pkg = pkg.trim();
                            if (pkg === '') {
                                return;
                            }
                            if (node.name === 'documentclass') {
                                pkg = 'class-' + pkg;
                            }
                            const pkgs = this.extension.manager.cachedContent[file].element.package;
                            if (pkgs) {
                                pkgs.push(pkg);
                            }
                            else {
                                this.extension.manager.cachedContent[file].element.package = [pkg];
                            }
                        });
                    }
                });
            }
            else {
                if (latex_utensils_1.latexParser.hasContentArray(node)) {
                    this.updatePkgWithNodeArray(file, node.content);
                }
            }
        });
    }
    getCmdFromNode(file, node, cmdList = []) {
        const cmds = [];
        if (latex_utensils_1.latexParser.isDefCommand(node)) {
            const name = node.token.slice(1);
            if (!cmdList.includes(name)) {
                const cmd = {
                    label: `\\${name}`,
                    kind: vscode.CompletionItemKind.Function,
                    documentation: '`' + name + '`',
                    insertText: new vscode.SnippetString(name + this.getArgsFromNode(node)),
                    filterText: name,
                    package: ''
                };
                cmds.push(cmd);
                cmdList.push(name);
            }
        }
        else if (latex_utensils_1.latexParser.isCommand(node)) {
            if (!cmdList.includes(node.name)) {
                const cmd = {
                    label: `\\${node.name}`,
                    kind: vscode.CompletionItemKind.Function,
                    documentation: '`' + node.name + '`',
                    insertText: new vscode.SnippetString(node.name + this.getArgsFromNode(node)),
                    filterText: node.name,
                    package: ''
                };
                if (isTriggerSuggestNeeded(node.name)) {
                    cmd.command = { title: 'Post-Action', command: 'editor.action.triggerSuggest' };
                }
                cmds.push(cmd);
                cmdList.push(node.name);
            }
            if (['newcommand', 'renewcommand', 'providecommand', 'DeclarePairedDelimiter', 'DeclarePairedDelimiterX', 'DeclarePairedDelimiterXPP'].includes(node.name) &&
                Array.isArray(node.args) && node.args.length > 0) {
                const label = node.args[0].content[0].name;
                let args = '';
                if (latex_utensils_1.latexParser.isOptionalArg(node.args[1])) {
                    const numArgs = parseInt(node.args[1].content[0].content);
                    for (let i = 1; i <= numArgs; ++i) {
                        args += '{${' + i + '}}';
                    }
                }
                if (!cmdList.includes(label)) {
                    const cmd = {
                        label: `\\${label}`,
                        kind: vscode.CompletionItemKind.Function,
                        documentation: '`' + label + '`',
                        insertText: new vscode.SnippetString(label + args),
                        filterText: label,
                        package: 'user-defined'
                    };
                    cmds.push(cmd);
                    this.definedCmds[label] = {
                        file,
                        location: new vscode.Location(vscode.Uri.file(file), new vscode.Position(node.location.start.line - 1, node.location.start.column))
                    };
                    cmdList.push(label);
                }
            }
        }
        if (latex_utensils_1.latexParser.hasContentArray(node)) {
            return cmds.concat(this.getCmdFromNodeArray(file, node.content, cmdList));
        }
        return cmds;
    }
    getArgsFromNode(node) {
        let args = '';
        if (!('args' in node)) {
            return args;
        }
        let index = 0;
        if (latex_utensils_1.latexParser.isCommand(node)) {
            node.args.forEach(arg => {
                ++index;
                if (latex_utensils_1.latexParser.isOptionalArg(arg)) {
                    args += '[${' + index + '}]';
                }
                else {
                    args += '{${' + index + '}}';
                }
            });
            return args;
        }
        if (latex_utensils_1.latexParser.isDefCommand(node)) {
            node.args.forEach(arg => {
                ++index;
                if (latex_utensils_1.latexParser.isCommandParameter(arg)) {
                    args += '{${' + index + '}}';
                }
            });
            return args;
        }
        return args;
    }
    getCmdFromContent(file, content) {
        const cmdReg = /\\([a-zA-Z@_]+(?::[a-zA-Z]*)?)({[^{}]*})?({[^{}]*})?({[^{}]*})?/g;
        const cmds = [];
        const cmdList = [];
        let explSyntaxOn = false;
        while (true) {
            const result = cmdReg.exec(content);
            if (result === null) {
                break;
            }
            if (result[1] === 'ExplSyntaxOn') {
                explSyntaxOn = true;
                continue;
            }
            else if (result[1] === 'ExplSyntaxOff') {
                explSyntaxOn = false;
                continue;
            }
            if (!explSyntaxOn) {
                const len = result[1].search(/[_:]/);
                if (len > -1) {
                    result[1] = result[1].slice(0, len);
                }
            }
            if (cmdList.includes(result[1])) {
                continue;
            }
            const cmd = {
                label: `\\${result[1]}`,
                kind: vscode.CompletionItemKind.Function,
                documentation: '`' + result[1] + '`',
                insertText: new vscode.SnippetString(this.getArgsFromRegResult(result)),
                filterText: result[1],
                package: ''
            };
            if (isTriggerSuggestNeeded(result[1])) {
                cmd.command = { title: 'Post-Action', command: 'editor.action.triggerSuggest' };
            }
            cmds.push(cmd);
            cmdList.push(result[1]);
        }
        const newCommandReg = /\\(?:(?:(?:re|provide)?(?:new)?command)|(?:DeclarePairedDelimiter(?:X|XPP)?))(?:{)?\\(\w+)/g;
        while (true) {
            const result = newCommandReg.exec(content);
            if (result === null) {
                break;
            }
            if (cmdList.includes(result[1])) {
                continue;
            }
            const cmd = {
                label: `\\${result[1]}`,
                kind: vscode.CompletionItemKind.Function,
                documentation: '`' + result[1] + '`',
                insertText: result[1],
                filterText: result[1],
                package: 'user-defined'
            };
            cmds.push(cmd);
            cmdList.push(result[1]);
            this.definedCmds[result[1]] = {
                file,
                location: new vscode.Location(vscode.Uri.file(file), new vscode.Position(content.substr(0, result.index).split('\n').length - 1, 0))
            };
        }
        return cmds;
    }
    getArgsFromRegResult(result) {
        let text = result[1];
        if (result[2]) {
            text += '{${1}}';
        }
        if (result[3]) {
            text += '{${2}}';
        }
        if (result[4]) {
            text += '{${3}}';
        }
        return text;
    }
    entryCmdToCompletion(itemKey, item) {
        const configuration = vscode.workspace.getConfiguration('latex-workshop');
        const useTabStops = configuration.get('intellisense.useTabStops.enabled');
        const backslash = item.command.startsWith(' ') ? '' : '\\';
        const label = item.label ? `${item.label}` : `${backslash}${item.command}`;
        const suggestion = {
            label,
            kind: vscode.CompletionItemKind.Function,
            package: 'latex'
        };
        if (item.snippet) {
            if (useTabStops) {
                item.snippet = item.snippet.replace(/\$\{(\d+):[^}]*\}/g, '$${$1}');
            }
            suggestion.insertText = new vscode.SnippetString(item.snippet);
        }
        else {
            suggestion.insertText = item.command;
        }
        suggestion.filterText = itemKey;
        suggestion.detail = item.detail;
        suggestion.documentation = item.documentation ? item.documentation : '`' + item.command + '`';
        suggestion.sortText = item.command.replace(/^[a-zA-Z]/, c => {
            const n = c.match(/[a-z]/) ? c.toUpperCase().charCodeAt(0) : c.toLowerCase().charCodeAt(0);
            return n !== undefined ? n.toString(16) : c;
        });
        if (item.postAction) {
            suggestion.command = { title: 'Post-Action', command: item.postAction };
        }
        else if (isTriggerSuggestNeeded(item.command)) {
            // Automatically trigger completion if the command is for citation, filename, reference or glossary
            suggestion.command = { title: 'Post-Action', command: 'editor.action.triggerSuggest' };
        }
        return suggestion;
    }
    provideCmdInPkg(pkg, suggestions, cmdList) {
        const configuration = vscode.workspace.getConfiguration('latex-workshop');
        const useOptionalArgsEntries = configuration.get('intellisense.optionalArgsEntries.enabled');
        // Load command in pkg
        if (!(pkg in this.packageCmds)) {
            let filePath = `${this.extension.extensionRoot}/data/packages/${pkg}_cmd.json`;
            if (!fs.existsSync(filePath)) {
                // Many package with names like toppackage-config.sty are just wrappers around
                // the general package toppacke.sty and do not define commands on their own.
                const indexDash = pkg.lastIndexOf('-');
                if (indexDash > -1) {
                    const generalPkg = pkg.substring(0, indexDash);
                    filePath = `${this.extension.extensionRoot}/data/packages/${generalPkg}_cmd.json`;
                }
            }
            this.packageCmds[pkg] = [];
            if (fs.existsSync(filePath)) {
                const cmds = JSON.parse(fs.readFileSync(filePath).toString());
                Object.keys(cmds).forEach(key => {
                    this.packageCmds[pkg].push(this.entryCmdToCompletion(key, cmds[key]));
                });
            }
        }
        // No package command defined
        if (!(pkg in this.packageCmds) || this.packageCmds[pkg].length === 0) {
            return;
        }
        // Insert commands
        this.packageCmds[pkg].forEach(cmd => {
            if (!useOptionalArgsEntries && this.getCmdName(cmd).includes('[')) {
                return;
            }
            if (!cmdList.includes(this.getCmdName(cmd))) {
                suggestions.push(cmd);
                cmdList.push(this.getCmdName(cmd));
            }
        });
    }
}
exports.Command = Command;
//# sourceMappingURL=command.js.map