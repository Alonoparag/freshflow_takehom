# from flask import Flask
from sqlalchemy import create_engine, text
import pandas as pd
from flask import Flask
import json
with open('./sql_command.sql','r') as sql_file:
    global query
    query = sql_file.read()

print(query)
app = Flask(__name__)
@app.route('/')
def home():
    uri = 'sqlite:///data.db'
    engine = create_engine(uri)

    df = pd.read_sql_query(sql = query, con = engine)
    df['labels'] = None
    for ind, row in df.iterrows():
        df.at[ind,'item_categories'] = eval(row['item_categories'])
        x = eval(row['tags']) +  eval(row['extra_categories'])
        # print(x)
        df.at[ind,'labels'] = x
    df = df[['item_number', 'ordering_day', 'delivery_day', 'sales_price_suggestion',
        'profit_margin', 'purchase_price', 'item_categories', 'labels', 'case', 'order', 'inventory']].copy()
    return_list =  list(map(json.dumps,df.to_dict(orient = 'records')))
    return_str = '<br><br>'.join(return_list)
    return json.dumps(return_str)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)