<script setup lang="ts">
import { ref } from 'vue';
import ScrollDetail from "@/components/ScrollDetail.vue";
import ScrollUtils, { type Scroll } from "@/services/ScrollUtils";

type mode = "guess" | "fadeout" | "done";

// Number of scrolls to display
const no_scrolls: number = 4;

// Indexes of the scrolls to be displayed; no_scrolls of them
const indexes = ref<number[]>([]);
// Index of the correct scroll
const correctIndex = ref<number>();
// The correct scroll
const correctScroll = ref<Scroll>();
//  Index of the scroll guessed by the user; -1 when not guessed, then changes to guessed index
const guessedScrollIndex = ref<number>(-1);

const currentMode = ref<mode>("guess");

pickScrolls();

// Pick no_scrolls randomly, and then select one of those as the correct one
function pickScrolls() {
  indexes.value = []; // Reset the list of scrolls

  while (indexes.value.length < no_scrolls) {
    let n = Math.floor(Math.random() * ScrollUtils.getScrolls().length);
    if (!indexes.value.includes(n)) {
      indexes.value.push(n);
    }
  }

  correctIndex.value =  indexes.value[Math.floor(Math.random() * no_scrolls)];
  correctScroll.value = ScrollUtils.getScrolls()[correctIndex.value];
}

function selectScroll(index: number) {
  currentMode.value = "fadeout";
  console.log("Selected scroll: " + index);
  if (index === correctIndex.value) {
    console.log("Correct!");
  } else {
    console.log("Incorrect!");
  }

  setTimeout(() => {
    // TODO Once the fadeout is done, remove the wrong elements entirely
    currentMode.value = "done";
  }, 1000);

}

function reset() {
  guessedScrollIndex.value = -1;
  currentMode.value = "guess";
  pickScrolls();
}

</script>

<template>
  <h2>Scroll description:</h2>
  <p>{{correctScroll?.desc}}</p>
  <br>
  <h2 :class="{hide: currentMode !==  'guess'}">Select the matching scroll image:</h2><br>
  <div id="picker" class="scroll-group">
    <div class="scroll-item"
         :class="{
           'correct': i === correctIndex && currentMode !== 'guess',
           'hide': i !== correctIndex && currentMode !== 'guess'
         }"
         v-for="i in indexes"
         :key="i"
         @click="selectScroll(i)">
      <scroll-detail :index="i" :hide-details="true"/>
    </div>
  </div>
  <br>
  <button :class="{'initiallyHidden': currentMode !== 'done'}" @click="reset()">RESET</button>
</template>

<style scoped>

.scroll-group {
  display: flex;
  justify-content: center;
  align-items: stretch;
  overflow-x: auto;
  gap: 20px;
  width: 100%;
}

.scroll-item {
  flex-basis: 100%;
  padding: 10px;
}

h2, p {
  text-align: center;
}

button {
  width: 100%;
  padding: 20px;
  border: 1px solid var(--color-text);
  background-color: var(--color-background);
  color: var(--color-text);
  cursor: pointer;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }
}

.correct {
  border: 1px solid var(--color-text);
  border-color: green !important;
}

.hide {
  animation: fadeOut 1s forwards;   /* forwards here means the final keyframe stays applied, IE they stay hidden */
}

.initiallyHidden {
  visibility: hidden;
}

@keyframes fadeOut {
  0% { opacity: 1; }
  100% { opacity: 0; }
}

</style>
