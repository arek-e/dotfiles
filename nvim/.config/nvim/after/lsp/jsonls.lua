-- JSON, with schemas supplied by SchemaStore if it is installed.
-- Loaded lazily so a missing SchemaStore does not break the server.

return {
  before_init = function(_, config)
    local ok, schemastore = pcall(require, "schemastore")
    config.settings = config.settings or {}
    config.settings.json = vim.tbl_deep_extend("force", config.settings.json or {}, {
      schemas = ok and schemastore.json.schemas() or {},
      validate = { enable = true },
    })
  end,
  settings = {
    json = {
      format = { enable = false }, -- prettier or biome formats JSON
    },
  },
}
