<!--
  Component presenting all the details of a scroll
  Input is the index of the scroll
-->
<script setup lang="ts">
import ScrollImage from "@/components/ScrollImage.vue";
import ScrollUtils, { type Scroll } from "@/services/ScrollUtils";


const props = defineProps<{
  index: number
  hideDetails: boolean
}>()

const scroll: Scroll = ScrollUtils.getScrolls()[props.index];
const color = `var(--color-scroll-${scroll.type})`;

</script>

<template>
  <h2 v-if="!hideDetails">{{ scroll.name }}</h2>
  <p v-if="!hideDetails" class="type">{{ scroll.type }}</p>
  <scroll-image :index="props.index" />
  <p v-if="!hideDetails">{{ scroll.desc }}</p>
  <p v-if="scroll.descEnhanced && !hideDetails"><br><em>Enhanced:</em> {{ scroll.descEnhanced }}</p>
</template>

<style scoped>

  h2, p {
    text-align: center;
  }

  p.type::first-letter {
    text-transform: uppercase;
  }

  p.type {
    color: v-bind('color')
  }


  em {
    font-weight: bold;
    color: var(--color-enhanced);
  }

</style>