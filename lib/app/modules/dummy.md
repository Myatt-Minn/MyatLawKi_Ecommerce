   Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white),
                  onPressed: () {
                    // Decrease quantity logic
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  color: ConstsConfig.secondarycolor,
                  child: Text('1', style: TextStyle(color: Colors.black)),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // Increase quantity logic
                  },
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Add to cart logic
                    },
                    child: Text('Add to Cart',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),



            //Color code
              Row(
                          children: controller.product.value!.variations
                              .where((variation) => variation.type == 'color')
                              .expand((variation) => variation.options)
                              .map((colorOption) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Handle color selection
                                  controller.selectedColor.value = colorOption[0].name;
                                },
                                child: CircleAvatar(
                                  backgroundColor: , // Adjust color mapping
                                  radius: 10,
                                ),
                              ),
                            );
                          }).toList(),
                        ),