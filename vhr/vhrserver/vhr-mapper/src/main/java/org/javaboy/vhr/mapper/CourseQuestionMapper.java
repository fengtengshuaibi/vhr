package org.javaboy.vhr.mapper;
import org.javaboy.vhr.model.CourseQuestion;
import java.util.List;

public interface CourseQuestionMapper {
    int deleteByPrimaryKey(Integer id);
    int insert(CourseQuestion record);
    int insertSelective(CourseQuestion record);
    CourseQuestion selectByPrimaryKey(Integer id);
    int updateByPrimaryKeySelective(CourseQuestion record);
    int updateByPrimaryKey(CourseQuestion record);
    List<CourseQuestion> getQuestionsByCourseId(Integer courseId);
    void deleteByCourseId(Integer courseId);
}
