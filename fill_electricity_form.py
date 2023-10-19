import time
import datetime
from selenium import webdriver
from selenium.webdriver.common.by import By

current_date = datetime.date.today().strftime("%d-%m-%Y").replace('-', '.')

url = ""


input_data = {
        'kn':'',
        'znomer': '',
        'name_client': '',
        'address': '',
        't2': 13378,
        't1': 3425,
        'phoneBG': '',
        'date_metering': current_date,
        'email': ''
    }

driver = webdriver.Chrome()
driver.get(url)


time.sleep(2)


inputs = driver.find_elements(By.CLASS_NAME, 'form-control')
for element in inputs:
    if element.get_attribute('id') == 'pod' or element.get_attribute('id') == 'instalation':
        continue
    element.send_keys(input_data[element.get_attribute('id')])


time.sleep(60)

