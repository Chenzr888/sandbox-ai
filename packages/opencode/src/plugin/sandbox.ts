import type { Hooks, PluginInput } from "@opencode-ai/plugin"

const DEFAULT_BASE_URL = "https://api.sandboxai.top/v1"

export async function SandboxAuthPlugin(_input: PluginInput): Promise<Hooks> {
  return {
    auth: {
      provider: "sandboxai",
      methods: [
        {
          label: "API Key",
          type: "api",
          prompts: [
            {
              type: "text",
              key: "key",
              message: "Enter your Sandbox AI API key (get one at https://sandboxai.top)",
              placeholder: "sk-...",
              validate: (value: string) =>
                value && value.trim().length > 0 ? undefined : "API key cannot be empty",
            },
          ],
        },
      ],
      async loader(getAuth) {
        const auth = await getAuth()
        if (auth.type !== "api") return {}
        return {
          apiKey: auth.key,
          baseURL: DEFAULT_BASE_URL,
        }
      },
    },
    provider: {
      id: "sandboxai",
      async models(provider) {
        return provider.models
      },
    },
  }
}
