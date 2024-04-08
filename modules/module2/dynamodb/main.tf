resource "aws_dynamodb_table" "http_get_items" {
    name = var.db_name
    billing_mode = "PROVISIONED" #"PAY_PER_REQUEST" 
    read_capacity  = 1
    write_capacity = 1
    hash_key       = "id"
    # range_key      = 
    attribute {
        name = "id"
        type = "S"
    }
    # attribute {
    #     name = "email"
    #     type = "S"
    # }
}

resource "aws_dynamodb_table_item" "items" {
    table_name = aws_dynamodb_table.http_get_items.name
    hash_key = aws_dynamodb_table.http_get_items.hash_key
    item = <<ITEM
    {
        "id": {"S":"email"},
        "1": {"S": "lcossell0@fastcompany.com"},
        "2": {"S": "vshulem1@cam.ac.uk"},
        "3": {"S": "tduffett2@jugem.jp"},
        "4": {"S": "sgockeler3@a8.net"},
        "5": {"S": "hrenouf4@naver.com"}

    }
    ITEM
}