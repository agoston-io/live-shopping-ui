const fs = require('fs')

module.exports = {
    devServer: {
        https: {
            key: fs.readFileSync(process.env.VUE_APP_HTTPS_CERTIFICAT_KEY_PATH || '/dev/null'),
            cert: fs.readFileSync(process.env.VUE_APP_HTTPS_CERTIFICAT_PATH || '/dev/null'),
        },
        public: process.env.BASE_URL,
        disableHostCheck: true
    },
    configureWebpack: {
        module: {
            rules: [
                {
                    test: /\.(gql|graphql)$/,
                    use: 'graphql-tag/loader'
                }
            ]
        }
    }
}