package com.hogwarts.auth

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class HogwartsAuthApplication

fun main(args: Array<String>) {
	runApplication<HogwartsAuthApplication>(*args)
}
