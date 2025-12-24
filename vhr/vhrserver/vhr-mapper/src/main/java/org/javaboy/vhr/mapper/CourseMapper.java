package org.javaboy.vhr.mapper;
import org.javaboy.vhr.model.Course;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface CourseMapper {
    int deleteByPrimaryKey(Integer id);
    int insert(Course record);
    int insertSelective(Course record);
    Course selectByPrimaryKey(Integer id);
    int updateByPrimaryKeySelective(Course record);
    int updateByPrimaryKey(Course record);
    List<Course> getAllCourses(@Param("keywords") String keywords);
    List<Course> getCoursesByTypeAndDept(@Param("type") String type, @Param("departmentId") Integer departmentId);
}
