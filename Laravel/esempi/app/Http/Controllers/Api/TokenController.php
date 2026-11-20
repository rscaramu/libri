<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class TokenController extends Controller
{
    public function store(Request $request): array
    {
        $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
            'device' => ['required', 'string', 'max:100'],
        ]);

        $user = User::firstWhere('email', $request->email);

        if (! $user
            || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Credenziali non valide.'],
            ]);
        }

        $abilities = $user->isStaff()
            ? ['books:read', 'books:write']
            : ['books:read'];

        return [
            'token' => $user
                ->createToken($request->device, $abilities)
                ->plainTextToken,
        ];
    }

    public function destroy(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->noContent();
    }
}
