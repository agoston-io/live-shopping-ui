
import { ApolloClient, InMemoryCache } from '@apollo/client/core'
import { relayStylePagination } from "@apollo/client/utilities";
import { HttpLink } from 'apollo-link-http'
import { split } from 'apollo-link'
import { WebSocketLink } from 'apollo-link-ws'
import { getMainDefinition } from 'apollo-utilities'
import { createApolloProvider } from '@vue/apollo-option'

const apolloClientUri = process.env.VUE_APP_BACKEND_GRAPHQL_URI;
const apolloClientWebSocketUri = process.env.VUE_APP_BACKEND_GRAPHQL_SUBSCRIPTION_URI;

const httpLink = new HttpLink({
    uri: apolloClientUri,
})
const wsLink = new WebSocketLink({
    uri: apolloClientWebSocketUri,
    options: {
        reconnect: true,
    },
})
const link = split(
    ({ query }) => {
        const definition = getMainDefinition(query)
        return definition.kind === 'OperationDefinition' &&
            definition.operation === 'subscription'
    },
    wsLink,
    httpLink
)

const apolloClient = new ApolloClient({
    link,
    cache: new InMemoryCache({
        typePolicies: {
            Query: {
                fields: {
                    broadcasts: relayStylePagination(),
                },
            },
        },
    })
})

const apolloProvider = createApolloProvider({
    defaultClient: apolloClient,
})

export default apolloProvider