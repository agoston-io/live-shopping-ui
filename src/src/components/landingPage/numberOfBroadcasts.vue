<template>
  <div class="row">
    <div class="col-12">Number of broadcasts</div>
    <div class="col-12"><hr class="mt-0" /></div>
    <div class="col-12" v-if="$apollo.queries.countBroadcasts.loading">
      Loading...
    </div>
    <div class="col-12" v-else>
      {{ countBroadcasts.totalCount }}
    </div>
  </div>
</template>

<script>
// GraphQL
import COUNT_BROADCAST from "../../graphql/countBroadcasts.gql";

export default {
  name: "number-of-broadcasts",
  data() {
    return {
      countBroadcasts: {},
    };
  },
  apollo: {
    countBroadcasts: {
      query: COUNT_BROADCAST,
    },
  },
};
</script>
