from sqlalchemy.orm import Session
from sqlalchemy import func
from .models import Course, Member, CourseTags, FavoriteCourse, CourseImage, RecommendationLog
from . import SessionLocal  # 데이터베이스 세션을 가져오는 경우


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def load_running_logs(filepath: str):
    import pandas as pd
    logs_df = pd.read_csv(filepath)
    logs_df = logs_df.drop_duplicates(subset=['member_id', 'course_id'])

    # course_id를 인덱스로 변환
    logs_df['course_id'] = logs_df['course_id'].astype('category').cat.codes
    return logs_df

def get_favorite_courses(db: Session, member_id: int):
    favorite_courses = db.query(FavoriteCourse).filter(FavoriteCourse.member_id == member_id).all()
    return favorite_courses


def get_courses(db: Session, area: str):
    courses = db.query(Course).filter(Course.course_id != 0, Course.area == area,Course.course_type == 'official').all()

    return courses


def get_course_tags(db: Session):
    course_tags = db.query(CourseTags).all()
    return course_tags

def get_members(db: Session):
    members = db.query(Member).all()
    return members

def get_recommendation_logs(db: Session):
    logs = db.query(RecommendationLog).all()
    return logs

# Example of using the CRUD functions
def main(filepath: str):
    with get_db() as db:  # Using the context manager to manage the session
        running_logs = load_running_logs(filepath)
        favorite_courses = get_favorite_courses(db)
        courses = get_courses(db)
        course_tags = get_course_tags(db)
        members = get_members(db)

        # Here you can do further processing with the loaded data

