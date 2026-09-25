# Java & Kotlin

Toolchain comes from **SDKMAN** (`sdk help`). Open Neovim from the project root (where
`build.gradle(.kts)`, `settings.gradle(.kts)` or `pom.xml` lives). The first open of a project
takes a while: the language server imports the Gradle/Maven build.

## SDKMAN (shell)
| Command | Action |
|---------|--------|
| `sdk list java` | All available JDKs (Temurin = `-tem`, GraalVM = `-graal`, …) |
| `sdk install java 21.0.8-tem` | Install a specific JDK (use an id from the list) |
| `sdk use java 21.0.8-tem` | Switch JDK in this shell only |
| `sdk default java 21.0.8-tem` | Change the default JDK |
| `sdk env init` | Create a `.sdkmanrc` pinning the current versions for this project |
| `cd project/` | With a `.sdkmanrc`, versions switch automatically |
| `sdk current` | Show versions in use |
| `sdk upgrade` | Upgrade outdated candidates |

## Build (shell aliases)
| Command | Action |
|---------|--------|
| `gw` | ./gradlew (the project's own Gradle version) |
| `gwb` / `gwt` / `gwr` | build / test / run |
| `gwt --tests 'com.acme.WalTest'` | Run one test class |
| `gwc` | clean |
| `mvnt` | mvn -q test |

## Java in Neovim
| Keys | Action |
|------|--------|
| `space tt` | Run all tests in this class (JUnit) |
| `space tr` | Run the test method under the cursor |
| `space tT` | Pick a test to run |
| `space dc` | Debug: pick a main class to run |
| `space co` | Organize imports |
| `space ca` | Code action: implement methods, generate getters/constructor/toString… |
| `space cxv` / `space cxc` | Extract variable / constant (also on a visual selection) |
| `space cxm` (visual) | Extract method |
| `space cgs` | Go to super implementation |
| `gd` / `gI` / `gr` | Definition / implementations / references |
| `:MasonInstall java-debug-adapter java-test`, restart nvim | Fix "missing adapter java" on `space dc` |

## Kotlin in Neovim
| Keys | Action |
|------|--------|
| `space cf` | Format with ktlint (also on save) |
| `space ca` | Code actions / quick fixes |
| `gd` / `gr` / `K` | Definition / references / docs |
| `space dc` | Debug (build first with `gwb`) |
| `ctrl-space` then `\|` then `gwt` | Tests: no in-editor runner for Kotlin — run Gradle in a tmux pane |
