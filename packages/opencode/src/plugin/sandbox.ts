import type { Hooks, PluginInput } from "@opencode-ai/plugin"

const PROVIDER_ID = "sandboxai"

export async function SandboxAuthPlugin(_input: PluginInput): Promise<Hooks> {
  return {
    auth: {
      provider: PROVIDER_ID,
      methods: [
        {
          label: "API Key",
          type: "api",
          prompts: [
            {
              type: "text",
              key: "key",
              message: "Enter your Sandbox AI API key (https://sandboxai.top)",
              placeholder: "sk-...",
              validate: (v: string) => (v && v.trim() ? undefined : "API key cannot be empty"),
            },
          ],
        },
      ],
      async loader(getAuth) {
        const auth = await getAuth()
        if (auth.type !== "api") return {}
        return {
          apiKey: auth.key,
          baseURL: process.env["SANDBOXAI_BASE_URL"] || "https://api.sandboxai.top/v1",
        }
      },
    },
  }
}
