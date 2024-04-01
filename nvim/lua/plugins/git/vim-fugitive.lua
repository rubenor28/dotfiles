return {
    "tpope/vim-fugitive",
    lazy = false,
    config = function()
        -- Configuración personalizada de vim-fugitive
        vim.cmd [[
          " Configura vim-fugitive para que muestre los
          " cambios en el código de manera más clara
          command! Gdiffsplit :Gdiffsplit
          command! Gdiff :Gdiff

          " Configura vim-fugitive para que muestre el
          "historial de commits de manera más clara
          command! Glog :Glog

          " Configura vim-fugitive para que muestre el
          " estado del repositorio de manera más clara
          command! Gstatus :Gstatus

          " Configura vim-fugitive para que muestre el
          " blame de manera más clara
          command! Gblame :Gblame
        ]]
      end
}
