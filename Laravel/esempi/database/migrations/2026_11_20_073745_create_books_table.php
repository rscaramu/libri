<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('books', function (Blueprint $table) {
            $table->id();
            $table->foreignId('author_id')->constrained()
                ->cascadeOnDelete();
            $table->string('title');
            $table->string('isbn', 13)->nullable()->unique();
            $table->unsignedSmallInteger('year');
            $table->unsignedSmallInteger('pages')->default(0);
            $table->decimal('price', 8, 2)->default(0);
            $table->string('format')->default('cartaceo');
            $table->text('description')->nullable();
            $table->boolean('available')->default(true);
            $table->timestamps();
            $table->softDeletes();

            $table->index(['title', 'year']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('books');
    }
};
