const fs = require('fs')

module.exports = {
    devServer: {
        https: {
            key: fs.readFileSync(process.env.VUE_APP_HTTPS_CERTIFICAT_KEY_PATH || '/dev/null'),
            cert: fs.readFileSync(process.env.VUE_APP_HTTPS_CERTIFICAT_PATH || '/dev/null'),
        },
        disableHostCheck: true
    },
    configureWebpack: {
        module: {
            rules: [
                {
                    test: /\.(?:js|mjs|cjs)$/,
                    exclude: {
                        and: [/node_modules/],
                        not: [
                            /@agoston-io\/client/,
                        ]
                    },
                    use: {
                        loader: 'babel-loader',
                        options: {
                            presets: [
                                ['@babel/preset-env', { targets: "defaults" }]
                            ]
                        }
                    }
                },
                {
                    test: /\.(gql|graphql)$/,
                    use: 'graphql-tag/loader'
                }
            ]
        }
    }
}