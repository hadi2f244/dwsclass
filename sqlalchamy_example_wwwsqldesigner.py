db_engine = sa.create_engine('sqlite:///db.sqlite')
metadata = sa.MetaData()


# Table definition - Role
# 
Role_table = sa.Table("Role", metadata,
    sa.Column('id', INTEGER, autoincrement=True, primary_key=True),
    # rules - list of rules (e.g. write / read )
    sa.Column('rules', VARCHAR))

# Table definition - User
# 
User_table = sa.Table("User", metadata,
    sa.Column('id', INTEGER, sa.ForeignKey("Project.creator_uid"), autoincrement=True, primary_key=True),
    sa.Column('first_name', VARCHAR),
    sa.Column('last_name', VARCHAR, nullable=True),
    sa.Column('username', VARCHAR),
    sa.Column('password', INTEGER),
    sa.Column('status', TINYINT),
    sa.Column('register_at', DATETIME, nullable=True),
    sa.Column('email', VARCHAR, nullable=True),
    sa.Column('last_login', DATETIME, nullable=True))

# Table definition - Project
# 
Project_table = sa.Table("Project", metadata,
    sa.Column('id', INTEGER, nullable=True, autoincrement=True, primary_key=True),
    sa.Column('name', VARCHAR),
    sa.Column('creator_uid', INTEGER),
    sa.Column('created_at', DATETIME),
    sa.Column('last_update', DATETIME, nullable=True),
    sa.Column('description', MEDIUMTEXT, nullable=True))

# Table definition - RoleBinding
# 
RoleBinding_table = sa.Table("RoleBinding", metadata,
    sa.Column('id', INTEGER, nullable=True, autoincrement=True, primary_key=True),
    sa.Column('pid', INTEGER, sa.ForeignKey("Project.id")),
    sa.Column('uid', VARCHAR, sa.ForeignKey("User.id")),
    sa.Column('rid', INTEGER, sa.ForeignKey("Role.id")))


# Mapping Objects
class Role():
    def __init__(self, id, rules):
        self.id = id
        self.rules = rules

    def __repr__(self):
        return "<Role('%s', '%s')>" % (self.id, self.rules)

class User():
    def __init__(self, id, first_name, last_name, username, password, status, register_at, email, last_login):
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.username = username
        self.password = password
        self.status = status
        self.register_at = register_at
        self.email = email
        self.last_login = last_login

    def __repr__(self):
        return "<User('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')>" % (self.id, self.first_name, self.last_name, self.username, self.password, self.status, self.register_at, self.email, self.last_login)

class Project():
    def __init__(self, id, name, creator_uid, created_at, last_update, description):
        self.id = id
        self.name = name
        self.creator_uid = creator_uid
        self.created_at = created_at
        self.last_update = last_update
        self.description = description

    def __repr__(self):
        return "<Project('%s', '%s', '%s', '%s', '%s', '%s')>" % (self.id, self.name, self.creator_uid, self.created_at, self.last_update, self.description)

class RoleBinding():
    def __init__(self, id, pid, uid, rid):
        self.id = id
        self.pid = pid
        self.uid = uid
        self.rid = rid

    def __repr__(self):
        return "<RoleBinding('%s', '%s', '%s', '%s')>" % (self.id, self.pid, self.uid, self.rid)


# Declare mappings
mapper(Role, Role_table)
mapper(User, User_table)
mapper(Project, Project_table)
mapper(RoleBinding, RoleBinding_table)

# Create a session
session = sessionmaker(bind=db_engine)