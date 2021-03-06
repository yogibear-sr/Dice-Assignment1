import random
import json
import boto3
import math
from collections import Counter


def lambda_handler(event, context):
    _no_dice = int(event['ndice'])
    _no_sides = int(event['nsides'])
    _no_times = int(event['nthrows'])

    totals = [ ]
    digits = [i for i in range(0, 10)]
    random_str = ""

    s3 = boto3.resource('s3')

    for _throws in range(0,_no_times):
        rolls = [random.randint(1, _no_sides) for _ in range(_no_dice)]
        totals.append(sum(rolls))

    for i in range(6):
        index = math.floor(random.random() * 10)
        random_str += str(digits[index])
        
    s3object = s3.Object('roll-the-dice0123456789','rolldice_output' + random_str + '.txt')
    s3object.put(
        Body=(bytes(json.dumps(Counter(totals)).encode('UTF-8')))
    )

    return {
        'statusCode': 200,
        'body': json.dumps(Counter(totals), indent = 4)
    }

