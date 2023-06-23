<script setup>
import { computed } from "vue";

const props = defineProps({
  image: {
    type: String,
    required: true,
  },
  imageOrder: {
    type: Number,
    required: true,
  },
});

const imageOrder = computed(() =>
  props.imageOrder === 1 ? "order-1" : "order-2"
);
const textAlignment = computed(() =>
  props.imageOrder === 1
    ? "text-right order-2 justify-end"
    : "text-left order-1 justify-start"
);

const resolvedImage = computed(() => {
  const url = import.meta.env.BASE_URL + props.image;
  const url_rep = url.replace(/\/\//g, "\/");
  console.log(url_rep);
  return url_rep;
});
</script>

<template>
  <div
    class="slidev-layout h-full grid image-x bg-purple-50 text-purple-900 dark:(bg-[#121212] text-purple-100) pb-[4px]"
  >
    <div class="my-auto flex">
      <div
        class="w-1/2 flex justify-center items-center p-8 max-h-md object-cover"
        :class="imageOrder"
      >
        <img
          :src="resolvedImage"
          class="rounded-2xl border-image h-full object-cover"
        />
      </div>
      <div class="w-1/2 flex flex-col justify-center" :class="textAlignment">
        <slot />
      </div>
    </div>
  </div>
</template>
