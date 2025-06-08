package com.example.zadanie_9

import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.appcompat.app.AppCompatActivity
import com.example.zadanie_9.databinding.ActivityMainBinding
import com.example.zadanie_9.model.Category

class CategoryActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    private val categories = listOf(
        Category(1, "Category 1"),
        Category(2, "Category 2"),
        Category(3, "Category 3")
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val categoryNames = categories.map { it.name }
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, categoryNames)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

        binding.spinnerCategories.adapter = adapter

        binding.spinnerCategories.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>?, view: View?, position: Int, id: Long
            ) {
                val selectedCategory = categories[position].id
                val products = when (selectedCategory) {
                    1 -> listOf("Product A1", "Product A2")
                    2 -> listOf("Product B1", "Product B2")
                    3 -> listOf("Product C1", "Product C2")
                    else -> listOf("Lack of products")
                }

                val productText = products.joinToString("\n")
                binding.textViewProducts.text = "Products for ${categories[position].name}:\n\n$productText"
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
                binding.textViewProducts.text = ""
            }
        }
    }
}