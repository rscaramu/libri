<?php

namespace App\Http\Requests;

use App\Enums\Format;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreBookRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'author_id' => ['required', 'exists:authors,id'],
            'year' => ['required', 'integer',
                'between:1450,' . (now()->year + 1)],
            'pages' => ['nullable', 'integer', 'min:1'],
            'price' => ['required', 'numeric', 'min:0'],
            'format' => ['required', Rule::enum(Format::class)],
            'isbn' => ['nullable', 'digits:13',
                Rule::unique('books', 'isbn')],
            'categories' => ['array'],
            'categories.*' => ['integer', 'exists:categories,id'],
        ];
    }

    public function attributes(): array
    {
        return [
            'title' => 'titolo',
            'author_id' => 'autore',
            'year' => 'anno',
        ];
    }

    public function messages(): array
    {
        return [
            'isbn.digits' => 'Il codice ISBN ha 13 cifre.',
            'isbn.unique' => 'Esiste un libro con questo ISBN.',
        ];
    }
}
