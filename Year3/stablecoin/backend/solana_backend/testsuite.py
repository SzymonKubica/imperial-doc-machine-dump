from solana.publickey import PublicKey
from solana.keypair import Keypair
from time import sleep

from solana_backend.api import fund_account
import json

from solana_backend.response import Failure

TEST_USERS_FILE = "solana_backend/users.txt"
TEST_USERS_NUMBER = 10

def create_account(username):
    ''' Create a test solana account (on the actual blockchain)

    This function creates a solana account by calling Keypair.generate(),
    it initialises an empty account on the network and returns the Keypair
    object associated with that account. That newly created account can
    then be funded with SOL by using the fund function.

    '''

    kp = Keypair.generate()

    save_user_credentials(username, kp.public_key, kp.secret_key)

    return kp.public_key

def save_user_credentials(username, public_key, secret_key):
    ''' Save user credentials by writing them to a text file (UNSAFE)

    This funciton saves user name and a public/secret keys associated with the
    user. It should be used by the testsuite to create new test user accounts.

    '''

    with open(TEST_USERS_FILE, 'r') as users_file:
        users = json.loads(users_file.read())

    # the public and private keys have different formats and hence we need to
    # convert the public one into a string
    data = {
        'public_key': str(public_key),
        'secret_key': secret_key.decode("latin-1"),
    }

    users[username] = data

    with open(TEST_USERS_FILE, 'wt') as outfile:
        json.dump(users, outfile)

def fund_user(username, amount):
    ''' Fund the user acount with the requested number of SOL.

    Args:
        username: A string representing the name of the user.
        amount: An integer number of SOL to be transferred to the account
    '''
    wallet = load_wallet(username)

    if wallet is None:
        print("Wallet for user: {} not found".format(username))
        return

    public_key = PublicKey(wallet['public_key'])

    resp = fund_account(public_key, amount)

    assert (resp is not None)

    if isinstance(resp, Failure):
        print("Failed to fund user account: {}".format(resp.to_json()['exception']))


def load_wallet(sender_username):
    ''' Loads the test user wallet stored in the file system.'''

    try:
        with open(TEST_USERS_FILE) as users_file:
            users = json.load(users_file)
            account = users[sender_username]
            account['secret_key'] = account['secret_key'].encode("latin-1")
            return account

    except Exception as e:
        print(e)

def provision_test_users():
    ''' Creates and funds TEST_USERS_NUMBER test user accounts. '''

    for i in range(TEST_USERS_NUMBER):
        user = 'test_user_{}'.format(i)
        create_account(user)
        fund_user(user, 1)
        sleep(60)
