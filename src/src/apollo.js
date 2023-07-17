import { ApolloClient, HttpLink, InMemoryCache, split } from '@apollo/client/core'
import { onError } from '@apollo/client/link/error'
import { relayStylePagination } from "@apollo/client/utilities";
import { WebSocketLink } from '@apollo/client/link/ws'
import { getMainDefinition } from '@apollo/client/utilities'
import { createApolloProvider } from '@vue/apollo-option'

const apolloClientUri = process.env.VUE_APP_BACKEND_GRAPHQL_URI;
const apolloClientWebSocketUri = process.env.VUE_APP_BACKEND_GRAPHQL_SUBSCRIPTION_URI;

const httpLink = new HttpLink({
    uri: apolloClientUri,
    credentials: 'include'
})
const wsLink = new WebSocketLink({
    uri: apolloClientWebSocketUri,
    options: {
        reconnect: true,
        connectionParams: {
            credentials: 'include',
        },
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

// Handle errors
const errorLink = onError(({ graphQLErrors, networkError }) => {
    if (graphQLErrors)
        graphQLErrors.map(({ message, locations, stack }) => {
            console.log(`[GraphQL error]: Message: ${message}, Location: ${locations}, Stack: ${stack}`)
        }
        )
    if (networkError) console.error(`[Network]: ${networkError}`)
})


const apolloClient = new ApolloClient({
    link: errorLink.concat(link),
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
