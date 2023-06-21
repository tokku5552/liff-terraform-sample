<template>
  <div
    v-if="title || social"
    class="bg-barBottom flex absolute w-full bottom-0 left-0 py-0.5 px-4 text-sm"
  >
    <div class="w-1/2 text-left">Slidev theme purplin</div>
    <div class="w-1/2 flex justify-end">
      <div class="flex justify-center items-center ml-4">
        <span class="flex justify-center item-center">
          <carbon:logo-github />
        </span>
        <span class="ml-0.5"> "tokku5552/liff-terraform-sample" </span>
      </div>

      <div class="flex justify-center items-center ml-4">
        <span class="flex justify-center item-center">
          <carbon:logo-twitter />
        </span>
        <span class="ml-0.5"> tokkuu </span>
      </div>

      <div class="flex justify-center items-center ml-4">
        <span class="flex justify-center item-center">
          <carbon:link />
        </span>
        <span class="ml-0.5"> pages </span>
      </div>
    </div>
  </div>
</template>
