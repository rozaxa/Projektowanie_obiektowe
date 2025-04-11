package com.example.zadanie3

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

data class User(val id: Int, val name: String)

@RestController
class UserController {

    @GetMapping("/users")
    fun getUser(): List<User> {
        return listOf(
            User(1, "Ann"),
            User(2, "Mark"),
            User(3, "Alex")
        )
    }
}
